%Steffen Docken
%18-3-23
%Code to run all other codes.

%% toy model
run("Toy_Model/Toy_Model_opt.m")

run("Toy_Model/Toy_Model_KD.m")

run("Toy_Model/toy_model_fig.m")

%% optimization
run("Adeniran_Model/Search_Opt_facil_1_V.m")

%% generating facilitation figures based on Adeniran et al. 2011 model
run("Adeniran_Model/Adeniran_r_facilitation_fig.m")

run("Adeniran_Model/Adeniran_r_facilitation_fig_falpha_beta_dependence.m")

run("Adeniran_Model/Adeniran_r_facilitation_fig_drug_rates_dependence.m")

run("Adeniran_Model/Adeniran_r_facilitation_fig_protocol_time_course.m")