%Steffen Docken
%9-10-22
%Code to generate global parameters

save_paper_figs = 1; %indicator of if figures are saved

if(~isfolder("Figs"))%creating the figure folder if it doesn't exist yet.
    mkdir Figs
end

paper_fig_loc = '../Figs/';

facil_opt_V = -40; %membrane potential we are maximizing facilitation at
Temp = 298; % in K (25 Celsius; Kazu says he keeps the recording room 
% between 23 and 26 Celsius)

K_o = 4; %mM is what Kazu said the [K]_out value was for experiments

%% protocol parameters

initial_hold_dur = 1e3;
prepulse_dur = 4e3;
hold_dur = 10e3;
test_pulse_dur = 4e3;
tail_dur = 1e3;

V_hold = -90;
V_stim = 60; 
V_tail = -60;%mV


%% baseline values for drug binding with no V-dependence

% Based on Furutani%s data [unpublished], nifekalant binding to hERG 
% expressed in HEK 293 cells has a K_D of approximately 100 nM, and a time 
% constant of drug binding of approximately 1s. Therefore, we use drug 
% binding parameters of k_on = 5e-3 nM^-1s^-1, and k_off = 5e-1 s^-1."
k_on_0 = (5e-3)*(1e9)*(1e-3); %(5e-3 nM^-1s^-1)*(1e9nM/M)*(1e-3s/ms) = 
% 5e3M^-1ms^-1
k_D0 = 100e-9; %M
D = 100e-9; %drug concentration of 100 nM (in M)

%initializing set of drug model parameters for Adeniran model codes
Drug_Model_pars_init.kon = k_on_0; %baseline drug binding rate constant
Drug_Model_pars_init.D = D; %baseline drug concentration
Drug_Model_pars_init.koff = k_D0*k_on_0; %baseline drug unbinding rate
Drug_Model_pars_init.A = 1; %initializing no shift in activation rates of 
%drug bound states
Drug_Model_pars_init.B = 1; %initializing no shift in deactivation rates of 
%drug bound states

%test voltage tailcurrent that GVs are normalized to
V_norm = 40; %mV

%Color scheme for plotting
plot_param.plot_colors = cell(2,2,2); %rows: no pre-pulse or with pre-pulse, 
% columns: -nifekalant or + nifekalant, 
% 3rd dimension: Current traces & GVs or State occupancies
plot_param.no_prepulse = 1; %indices for different characteristics
plot_param.with_prepulse = 2;
plot_param.no_nifekalant = 1;
plot_param.nifekalant = 2;
plot_param.Current_GV = 1;
plot_param.State_occ = 2;

plot_param.plot_colors{plot_param.no_prepulse, plot_param.no_nifekalant, ...
    plot_param.Current_GV} = '#231F20';
plot_param.plot_colors{plot_param.no_prepulse, plot_param.nifekalant, ...
    plot_param.Current_GV} = '#8DC63F';
plot_param.plot_colors{plot_param.no_prepulse, plot_param.no_nifekalant, ...
    plot_param.State_occ} = '#231F20';
plot_param.plot_colors{plot_param.no_prepulse, plot_param.nifekalant, ...
    plot_param.State_occ} = '#009444';
plot_param.plot_colors{plot_param.with_prepulse, plot_param.no_nifekalant, ...
    plot_param.Current_GV} = '#6D6E71';
plot_param.plot_colors{plot_param.with_prepulse, plot_param.nifekalant, ...
    plot_param.Current_GV} = '#00AEEF';
plot_param.plot_colors{plot_param.with_prepulse, plot_param.no_nifekalant, ...
    plot_param.State_occ} = '#6D6E71';
plot_param.plot_colors{plot_param.with_prepulse, plot_param.nifekalant, ...
    plot_param.State_occ} = '#21409A';

plot_param.font_size = 8;
plot_param.font_type = 'Times New Roman';

plot_param.LineWidth = 0.5;
plot_param.MarkerSize = 2;

plot_param.TickLength = 8; %to be used with set(gca,'TickLength',XXX)
plot_param.TickDir = 'out'; % to be used with set(gca,'TickDir',ZZZ);

%indices of various states
Ind.C1 = 10;
Ind.C2 = 1;
Ind.C3 = 2;
Ind.O = 3;
Ind.I = 4;
Ind.DC1 = 5;
Ind.DC2 = 6;
Ind.DC3 = 7;
Ind.DO = 8;
Ind.DI = 9;

%% figure sizes
axis_offset = 1; %to create 1 inch padding around axes

fig_position = @(X)[axis_offset, axis_offset, ...
    X.width + 2*axis_offset, X.height + 2*axis_offset];
%function to get vectors used to define Position property of figures

axis_innerposition = @(X)[axis_offset/(X.width + 2*axis_offset),...
    axis_offset/(X.height + 2*axis_offset), ...
    X.width/(X.width + 2*axis_offset),...
    X.height/(X.height + 2*axis_offset)];
%function to get vectors used to define InnerPosition property of axes

fig_units = 'inches';

%figure 2 axes dimensions
fig2B_dim.width = 1.5;
fig2B_dim.height = 0.85;

fig2Cmain_dim.width = 1.5;
fig2Cmain_dim.height = 0.7;

fig2Cinset_dim.width = 1.07;
fig2Cinset_dim.height = 0.57;

fig2D_dim.width = 1.5;
fig2D_dim.height = 1.0;

fig2E_dim.width = 1.07;
fig2E_dim.height = 0.68;

fig2FandG_dim.width = 1.5;
fig2FandG_dim.height = 0.9;

%figure 6 axes dimensions
fig6B_dim.width = 1.0; 
fig6B_dim.height = 0.5;

fig6CtoE_left_dim.width = 2.0;
fig6CtoE_left_dim.height = 0.9;

fig6CtoE_right_dim.width = 1.7;
fig6CtoE_right_dim.height = 0.9;

%    Figure 7
fig7A_dim.width = 1.2;
fig7A_dim.height = 1.2;

fig7B_dim.width = 0.9;
fig7B_dim.height = 0.9;

fig7C_dim.width = 1.2;
fig7C_dim.height = 1.2;

fig7D_dim.width = 0.9;
fig7D_dim.height = 0.9;

%    Figure 8
fig8AtoD_dim.width = 1.1;
fig8AtoD_dim.height = 0.8;

fig8Epanels_dim.width = 1.1;
fig8Epanels_dim.height = 0.55;