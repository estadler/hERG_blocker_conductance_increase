%Steffen Docken
%9-10-22
%Code to optimize facilitation shifts

%Experimental Conditions

Prepulse_flag = 1; %use prepulse
include_Drug_it = 1; %include drug

%initial parameter guesses
log_facil_shift_pars_init = [log(10), log(0.1)]; %initial guesses for ln(A), ln(B)

%setting drug rates
Drug_rates.D = Drug_Model_pars_init.D;
Drug_rates.kon = Drug_Model_pars_init.kon;
Drug_rates.koff = Drug_Model_pars_init.koff;

min_fcn = @(log_facil_shift_pars)(-Exp_protocol_peak_tail_only_opt(facil_opt_V, ...
    Prepulse_flag, log_facil_shift_pars, Drug_rates, include_Drug_it));

[log_opt_facil_pars, neg_peak_tail] = fminsearch(min_fcn, log_facil_shift_pars_init);

opt_facil_pars.A = exp(log_opt_facil_pars(1));
opt_facil_pars.B = exp(log_opt_facil_pars(2));

%keyboard

save("Opt_facil_params.mat", "opt_facil_pars");