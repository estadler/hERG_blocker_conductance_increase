%Steffen Docken
%8-10-22
%Code to run reduced Adeniran et al. hERG model through facillitation protocol

%V_test: the test potential for this run
%Prepulse_flag: contains if a prepulse is applied or not (1 = yes, 0 = no)
%Drug_Model_pars: Drug rates and fold change in activation and deactivation rates
%include_Drug: whether drug is present (1) or not (0)

function [peak_tail, t_vec, state_timecourse, flux_timecourse] = ...
    Exp_protocol(V_test, Prepulse_flag, Drug_Model_pars, include_Drug)

run("../hERG_study_global_params.m") %loading global parameters

dt = 50; %in ms
t = 0:dt:(initial_hold_dur + prepulse_dur + hold_dur + ...
    test_pulse_dur + tail_dur);
N_t = length(t);
V_vec = zeros(N_t, 1); %will contain V time course for protocol

hERG_cond_array = zeros(N_t, 9);%This array will hold the hERG states 
%time course throughout the protocol (not including C1).

%prepulse
    
if (include_Drug == 0)
    Drug_Model_pars.D = 0; %confirming no drug included
end

options_steady_state = optimoptions('fsolve','TolFun', 1e-12,...
    'Display','off');

if(include_Drug == 1)
    X_guess = zeros(9,1);
    X_guess(5) = 0.5; %initializing guess as with all channels in C1 state 
    % if no drug present or half in C1 and half in DC1 if drug present

    X_init = fsolve(@(X)Adeniran_r_drug_RHS(0, X, V_hold, K_o, ...
        Drug_Model_pars, Temp), X_guess, options_steady_state)';
else
    X_guess = zeros(4,1);
    
    % no drug present
    X_no_drug_init = fsolve(@(X)Adeniran_r_no_drug_RHS(0, X, V_hold, K_o, ...
        Drug_Model_pars, Temp), X_guess, options_steady_state)';

    X_init = [X_no_drug_init, zeros(1,5)];
end

[~, X_sol] = ode15s(@(t, X)Adeniran_r_drug_RHS(t, X, V_hold, K_o,...
    Drug_Model_pars, Temp), 0:dt:initial_hold_dur, X_init);

[m, ~] = max(abs(X_init - X_sol(end,:)));
if(m > 5e-10)
    disp(strcat("ERROR: initial Steady State not reached; m = ", num2str(m)));
end


hERG_cond_array(1:initial_hold_dur/dt+1, :) = X_sol;
V_vec(1:initial_hold_dur/dt+1) = V_hold;

if (Prepulse_flag == 1) %prepulse used 
    [~, X_sol] = ode15s(@(t, X)Adeniran_r_drug_RHS(t, X, V_stim, K_o,...
        Drug_Model_pars, Temp), 0:dt:prepulse_dur, X_sol(end,:)); %updating system through
    %4 second stimulus

    V_vec((initial_hold_dur/dt+1):(initial_hold_dur + prepulse_dur)/dt+1) = V_stim;
    %keyboard
elseif (Prepulse_flag == 0) %no prepulse
    [~, X_sol] = ode15s(@(t, X)Adeniran_r_drug_RHS(t, X, V_hold, K_o,...
        Drug_Model_pars, Temp), 0:dt:prepulse_dur, X_sol(end,:)); %updating system through
    %4 second stimulus

    V_vec((initial_hold_dur/dt+1):(initial_hold_dur + prepulse_dur)/dt+1) = V_hold;
    %keyboard
else
    disp("ERROR: prepulse flag not recognized")
end
hERG_cond_array((initial_hold_dur/dt+1):(initial_hold_dur + prepulse_dur)/dt+1, :) = X_sol;

[~, X_sol] = ode15s(@(t, X)Adeniran_r_drug_RHS(t, X, V_hold, K_o,...
    Drug_Model_pars, Temp), 0:dt:hold_dur, X_sol(end,:)); %updating system through
%10 second at holding V
hERG_cond_array((initial_hold_dur + prepulse_dur)/dt+1:...
    (initial_hold_dur + prepulse_dur + hold_dur)/dt +1, :) = X_sol;
V_vec((initial_hold_dur + prepulse_dur)/dt+1:...
    (initial_hold_dur + prepulse_dur + hold_dur)/dt +1) = V_hold;

[~, X_sol] = ode15s(@(t, X)Adeniran_r_drug_RHS(t, X, V_test, K_o,...
    Drug_Model_pars, Temp), 0:dt:test_pulse_dur, X_sol(end,:)); %updating system through
%10 second at holding V
hERG_cond_array((initial_hold_dur + prepulse_dur + hold_dur)/dt +1:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+1, :) = X_sol;
V_vec((initial_hold_dur + prepulse_dur + hold_dur)/dt +1:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+1) = V_test;


[~, X_tail] = ode15s(@(t, X)Adeniran_r_drug_RHS(t, X, V_tail, K_o,...
    Drug_Model_pars, Temp), 0:dt:tail_dur, X_sol(end,:)); %making 
        %toy_hERG_drug_avail just a function of t for fminbnd and taking the
        %negative of the function, so finding the min finds the time of
        %the max conductance
hERG_cond_array((initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+1:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur + tail_dur)/dt+1, :) = X_tail;
V_vec((initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+1:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur + tail_dur)/dt+1) = V_tail;

peak_tail = max(X_tail(:,Ind.O)); %maximum tail current

t_vec = t;

state_timecourse = [hERG_cond_array, 1-sum(hERG_cond_array, 2)]; 
%timecourse of state occupancy. last column is C1 (1-sum of other channels)

flux_timecourse = zeros(N_t, 10); %will contain fluxes between states

for ii = 1:N_t
    flux_timecourse(ii,:) = Adeniran_r_drug_flux(t(ii), hERG_cond_array(ii,:),...
        V_vec(ii), K_o, Drug_Model_pars, Temp);
end
