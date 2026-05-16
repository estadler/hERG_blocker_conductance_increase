%Steffen Docken
%8-10-22
%Code to run reduced Adeniran et al. hERG model through facillitation 
% protocol and only return peak tail current

%V_test: the test potential for this run
%Prepulse_flag: contains if a prepulse is applied or not (1 = yes, 0 = no)
%Drug_Model_pars: Drug rates and fold change in activation and deactivation rates
%include_Drug: whether drug is present (1) or not (0)

function peak_tail = Exp_protocol_peak_tail_only(V_test, Prepulse_flag, ...
    Drug_Model_pars, include_Drug)

[peak_tail, ~, ~, ~] = Exp_protocol(V_test, Prepulse_flag, Drug_Model_pars,...
    include_Drug);