%Steffen Docken
%8-10-22
%Code to optimize parameters for 4 state toy model of hERG (Closed, Open, Drug
%bound Closed, and Drug Bound Open)

clear
close all

%% loading the data
Act_data = readmatrix("summary GV.xlsx", "Range", "B6:C20");

run("../hERG_study_global_params.m");

Act_data_max_norm = Act_data(:,2)/max(Act_data(:,2)); % activation 
% data normalized to maximal value, not at 30mV
Act_data_norm_V_ind = find(Act_data(:,2) == 1); %finding the index for the 
% row of the test voltage activation data was normalized to.

%defining the on and off rates based on [D], k_on_0, and k_D0 from the global 
% parameters
Dkon = D*k_on_0; %in ms^-1
k_off = k_on_0*k_D0; %in ms^-1

%% optimizing alpha_hat and beta_hat to steady state activation
alpha_hat_fcn = @(V, p1, p2)exp((V-p1)/p2);
beta_hat_fcn = @(V, p1, p2)exp((V-p1)/(-p2));

Model_SS_Act = @(V, pars)(1./ ...
    (1 + exp(-2*(V-pars(1))/pars(2))));

cost_fcn = @(pars)(sum((Act_data_max_norm - ...
    Model_SS_Act(Act_data(:,1), pars)).^2)); %sum-squared difference between
%activation data and model activation curve

act_pars = fminsearch(cost_fcn, [0;10]);

tau = 1e3; %in ms, rough estimate of activation rate of hERG channel at 
% -40 mV

z = 1/tau*1/(alpha_hat_fcn(-40, act_pars(1), act_pars(2)) +...
    beta_hat_fcn(-40, act_pars(1), act_pars(2))); %computing the factor to
%adjust alpha and beta by to get the desired time constant.

%best fit rate fcns
alpha = @(V)z*alpha_hat_fcn(V, act_pars(1), act_pars(2));
beta = @(V)z*beta_hat_fcn(V, act_pars(1), act_pars(2));

%30 mV left shift in act curve
s_left = 30; %mV leftward shift in steady state activation
k = exp(2*s_left/act_pars(2)); %calculation of ratio of shift in Beta to shift in alpha for 
%30 mV shift in activaiton curve

%% saving toy model parameters
toy_model_params.z = z;
toy_model_params.p1 =  act_pars(1);
toy_model_params.p2 =  act_pars(2);
toy_model_params.k = k;

save('toy_model_params.mat', "toy_model_params");
