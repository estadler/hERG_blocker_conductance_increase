%Steffen Docken
%8-10-22
%Code to run toy hERG model through facillitation protocol

%V_test: the test potential for this run
%Prepulse_flag: contains if a prepulse is applied or not (1 = yes, 0 = no)
%include_Drug: whether drug is present (1) or not (0)
%facilitory_Drug: whether drug is facilatory (1) or not (0)

function [peak_tail, t_vec, state_timecourse, flux_timecourse, V_timecourse] = ...
    Exp_protocol_toy(V_test, Prepulse_flag, include_Drug, facilitory_Drug)

run("../hERG_study_global_params.m") %loading global parameters

load('toy_model_params.mat');

dt = 50; %in ms
t = 0:dt:(initial_hold_dur + prepulse_dur + hold_dur + ...
    test_pulse_dur + tail_dur);
N_t = length(t);
V_timecourse = zeros(N_t, 1); %will contain V time course for protocol

hERG_cond_array = zeros(N_t, 3);%This array will hold the hERG states 
%time course throughout the protocol (not including C^*).

%prepulse
    
if (include_Drug == 1)
    Dkon  = D*k_on_0;
elseif (include_Drug == 0)
    Dkon = 0; %no drug
else
    disp("ERROR: include_Drug nonsensical");
end
koff = k_on_0*k_D0;

Drug_Model_pars = [Dkon, koff, toy_model_params.z, toy_model_params.p1,...
    toy_model_params.p2, toy_model_params.k];
%Parameters for facilitatory drug

if (facilitory_Drug == 0)
    Drug_Model_pars(6) = 1; %removing shift in activation rate for non-
    %facilitatory drug
elseif (facilitory_Drug ~= 1)
    disp("ERROR: facilitatory_Drug nonsensical")
end

X_init = toy_model_drug_steady_state(V_hold, Drug_Model_pars);

[~, X_sol] = ode15s(@(t, X)toy_model_drug_RHS(t, X, V_hold,...
    Drug_Model_pars), 0:dt:initial_hold_dur, X_init);

[m, ~] = max(abs(X_init - X_sol(end,:)));
if(m > 5e-10)
    disp(strcat("ERROR: initial Steady State not found; m = ", num2str(m)));
end

hERG_cond_array(1:initial_hold_dur/dt+1, :) = X_sol;
V_timecourse(1:initial_hold_dur/dt+1) = V_hold;

if (Prepulse_flag == 1) %prepulse used 
    [~, X_sol] = ode15s(@(t, X)toy_model_drug_RHS(t, X, V_stim,...
        Drug_Model_pars), 0:dt:prepulse_dur, X_sol(end,:)); %updating system through
    %4 second stimulus

    V_timecourse((initial_hold_dur/dt+2):(initial_hold_dur + prepulse_dur)/dt+1) = V_stim;
    %keyboard
elseif (Prepulse_flag == 0) %no prepulse
    [~, X_sol] = ode15s(@(t, X)toy_model_drug_RHS(t, X, V_hold,...
        Drug_Model_pars), 0:dt:prepulse_dur, X_sol(end,:)); %updating system through
    %4 second stimulus

    V_timecourse((initial_hold_dur/dt+2):(initial_hold_dur + prepulse_dur)/dt+1) = V_hold;
    %keyboard
else
    disp("ERROR: prepulse flag not recognized")
end

hERG_cond_array((initial_hold_dur/dt+1):(initial_hold_dur + prepulse_dur)/dt+1, :) = X_sol;

[~, X_sol] = ode15s(@(t, X)toy_model_drug_RHS(t, X, V_hold,...
    Drug_Model_pars), 0:dt:hold_dur, X_sol(end,:)); %updating system through
%10 second at holding V
hERG_cond_array((initial_hold_dur + prepulse_dur)/dt+1:...
    (initial_hold_dur + prepulse_dur + hold_dur)/dt +1, :) = X_sol;
V_timecourse((initial_hold_dur + prepulse_dur)/dt+2:...
    (initial_hold_dur + prepulse_dur + hold_dur)/dt +1) = V_hold;

[~, X_sol] = ode15s(@(t, X)toy_model_drug_RHS(t, X, V_test,...
    Drug_Model_pars), 0:dt:test_pulse_dur, X_sol(end,:)); %updating system through
%test pulse
hERG_cond_array((initial_hold_dur + prepulse_dur + hold_dur)/dt +1:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+1, :) = X_sol;
V_timecourse((initial_hold_dur + prepulse_dur + hold_dur)/dt +2:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+1) = V_test;


[~, X_tail] = ode15s(@(t, X)toy_model_drug_RHS(t, X, V_tail,...
    Drug_Model_pars), 0:dt:tail_dur, X_sol(end,:)); 
%updating system through tail pulse
hERG_cond_array((initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+1:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur + tail_dur)/dt+1, :) = X_tail;
V_timecourse((initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur)/dt+2:...
    (initial_hold_dur + prepulse_dur + hold_dur + test_pulse_dur + tail_dur)/dt+1) = V_tail;

peak_tail = max(X_tail(:,1)); %maximum tail current

t_vec = t;

state_timecourse = [hERG_cond_array, 1-sum(hERG_cond_array, 2)]; 
%timecourse of state occupancy. last column is C (1-sum of other channels)

flux_timecourse = zeros(N_t, 3); %will contain fluxes between states

for ii = 1:N_t
    flux_timecourse(ii,:) = toy_model_drug_flux(t(ii), hERG_cond_array(ii,:),...
        V_timecourse(ii), Drug_Model_pars);
end