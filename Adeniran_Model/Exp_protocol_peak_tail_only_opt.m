%Steffen Docken
%9-30-25
%Code to call Exp_protocol_peak_tail_only but with different variable
%designation to allow use in optimization

%V_test: the test potential for this run
%Prepulse_flag: contains if a prepulse is applied or not (1 = yes, 0 = no)
%log_facil_shifts: ln() of drug bound activation and deactivation shifts
%Drug_rates: D, kon, and koff
%include_Drug: whether drug is present (1) or not (0)

function peak_tail = Exp_protocol_peak_tail_only_opt(V_test, Prepulse_flag, ...
    log_facil_shift_pars, Drug_rates, include_Drug)

%converting naming of Drug_rates
Drug_Model_pars.kon = Drug_rates.kon; %drug binding rate constant
Drug_Model_pars.D = Drug_rates.D; %drug concentration
Drug_Model_pars.koff = Drug_rates.koff; %drug unbinding rate

%converting naming of facilitation rate
Drug_Model_pars.A = exp(log_facil_shift_pars(1)); %shift in activation rate
Drug_Model_pars.B  = exp(log_facil_shift_pars(2)); %shift in deactivation rates

peak_tail = Exp_protocol_peak_tail_only(V_test, Prepulse_flag, ...
    Drug_Model_pars, include_Drug);