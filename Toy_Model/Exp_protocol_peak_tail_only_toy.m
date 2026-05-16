%Steffen Docken
%8-10-22
%Code to run toy hERG model through facillitation 
% protocol and only return peak tail current

%V_test: the test potential for this run
%Prepulse_flag: contains if a prepulse is applied or not (1 = yes, 0 = no)
%include_Drug: whether drug is present (1) or not (0)
%facilitory_Drug: whether drug is facilatory (1) or not (0)

function peak_tail = Exp_protocol_peak_tail_only_toy(V_test, Prepulse_flag, ...
    include_Drug, facilitory_Drug)

[peak_tail, ~, ~, ~, ~] = Exp_protocol_toy(V_test, Prepulse_flag, include_Drug,...
    facilitory_Drug);