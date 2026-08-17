# hERG_blocker_conductance_increase #test
This repository contains all code and data for the mathematical simulations presented in "A hERG Blocker Facilitates K+ Channel Current by Promoting Pore Opening while Blocking" by Steffen Docken, Matthew Marquis, Khoa Ngo, Yuumu Wada, Satomi Kita, Vladimir Yarov-Yarovoy, Colleen Clancy, Igor Vorobyov, Timothy Lewis, Kazuharu Furutani, and Jon Sack (DOI: 10.1085/jgp.202614015).

Running Driver.m will run all scripts in the appropriate order to generate all mathematical modeling results and figures in the manuscript. Note, some scripts use parralel for loops (parfor), which require the Parallel Computing toolbox. If the user does not have access to the Parallel Computing toolbox, these will need to be changed to standard for loops. The rest of this README file gives a brief overview of the various scripts and functions.

# Parent folder
- Driver.m: runs all scripts to regenerate results in the manuscript
- hERG_study_global_params.m: contains all global parameters used in multiple codes. E.g., protocol parameters and figure settings.

# Toy_Model
This folder contains all code relevant to the Toy Model used to illustrate the proposed mechanism for hERG faciliation.
- summary GV.xlsx: contains the steady state activation data the model is parameterized with.
- Toy_Model_opt.m: script that fits the model parameters as described in the Methods.
- Toy_Model_KD.m: plots the steady state activation curve and the dissociation constant as a function of voltage in this model.
- toy_model_fig.m: runs the maximal conductance simulations and generates the corresponding plots of maximal conductance vs. test pulse voltage and time courses of conductance and state occupancy. This code makes use of the following three codes.
  - toy_model_drug_steady_state.m: takes voltage and drug binding parameters as inputs and calculates the steady state occupancy of each channel state for that voltage.
  - toy_model_drug_RHS.m: defines the right-hand side of the system of differential equations that comprise the toy model.
  - toy_model_drug_flux.m: calculates the instantaneous fluxes between channel states.
  - Exp_protocol_toy.m: simulates a maximal conductance protocol with the defined input parameters (test pulse potential, if there is a pre-pulse, if drug is present, and if the drug is a facilitating drug or not). Output is peak open state occupancy during the tail step, vector of time points, corresponding channel state occupancies, time course of flux between states, and voltage time course.
  - Exp_protocol_peak_tail_only_toy.m: runs Exp_protocol_toy.m, but only returns to peak tail open state occupancy.

# Adeniran_Model
This folder contains all code relevant to the modified Adeniran model.
- Seach_Opt_facil_1_V.m: script that finds the drug induced shifts in activation rates constants that cause the greatest level of facilitation at the chosen voltage (facil_opt_V) given the set drug concentration. Optimal shifts in activation and deactivation rate constants are saved in Opt_facil_params.mat. This code uses the Exp_protocol_peak_tail_only_opt function.
- Adeniran_r_facilitation_fig.m: runs the maximal conductance simulations and generates the corresponding plots of maximal conductance vs. test voltage, state occupancy and state transition time course. This code makes use of the following four codes. This code makes use of the Exp_protocol_peak_tail_only and Exp_protocol functions.
- Adeniran_r_facilitation_fig_falpha_beta_dependence.m: runs maximal conductance simulations to examine the dependence of facilitation on drug induced shifts in activation and or deactivation rate constants. This code makes use of the Exp_protocol_peak_tail_only function.
- Adeniran_r_facilitation_fig_drug_rates_dependence.m: runs maximal conductance simulations to examine the dependence of facilitation on drug concentration and drug binding and unbinding rate constants. Drug induced shifts in activation and deactivation rate constants are set to optimize facilitation at the baseline drug concentration. The code also calculates the rate constant for the O to C3 state transition at negative 40mV. This code makes use of the Exp_protocol_peak_tail_only and Adeniran_r_O_to_C3_rateconstant functions.
- Adeniran_r_facilitation_fig_protocol_time_course.m: generates plots of channel state occupancies during maximal conductance simulations. This code makes use of the Exp_protocol function.

Codes called by main scripts of Adeniran_Model folder: 
  - Adeniran_r_drug_flux.m: outputs the instantaneous state transition rates given voltage, state occupancy, and model and protocol parameters.
  - Adeniran_r_drug_RHS.m: defines the right-hand side of the system of differential equations that comprise the modified Adeniran model.
  - Adeniran_r_no_drug_RHS.m: defines the right-hand side of the system of differential equations that comprise the Adeniran model with no drug present.
  - Adeniran_r_O_to_C3_rateconstant.m: calculates the rate constant for the O to C3 state transition given voltage and temperature.
  - Exp_protocol.m: simulates a maximal conductance protocol with the defined input parameters (test pulse potential, if there is a pre-pulse, drug parameters, and if drug is present). Output is peak tail conductance, vector of time points, corresponding channel state occupancies, and instantaneous transition rates.
  - Exp_protocol_peak_tail_only.m: runs Exp_protocol.m, but only returns to peak tail conductance.
  - Exp_protocol_peak_tail_only_opt.m: takes as inputs 1) drug induced shifts in activation and deactivation rate constants and 2) drug binding rate constants (and test pulse potential, if there is a pre-pulse, and if drug is present). The code then combines drug induced shifts in activation and deactivation rate constants and drug binding rate constantsruns into Drug_Model_pars to run Exp_protocol_peak_tail_only.m.

# Figs
Folder created by running hERG_study_global_params.m, which contains all output figures
