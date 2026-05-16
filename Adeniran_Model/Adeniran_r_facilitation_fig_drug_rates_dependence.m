%Steffen Docken
%9-24-25
%Code to generate output of second Adeniran model figure (panels C and D)

clear
close all

%Experimental Conditions
run("../hERG_study_global_params.m")

%optimal faciliation factors
load Opt_facil_params.mat

D_vec = Drug_Model_pars_init.D*10.^(-2:0.02:2); %vector of [D] values

N_D = length(D_vec);

%% panel C

Prepulse_flag_it = 1; %prepulse
include_Drug_it = 1; %Drug


for ii = 1:2 %loop faciliatory and non-faciliatory drug
    peak_Cond_vec = zeros(N_D, 1);
    Drug_Model_pars_it = Drug_Model_pars_init; %initializing Drug model
    %parameters
    
    if(ii == 1) %faciliatory drug
        Drug_Model_pars_it.A = opt_facil_pars.A;
        Drug_Model_pars_it.B = opt_facil_pars.B;
    end %if ii == 2, A and B are left as 1 (as in Drug_Model_pars_init)

    % generating peak conduction vs. [D]
    for kk = 1:N_D
        
        Drug_Model_pars_it.D = D_vec(kk);
        %changing [D]

        peak_Cond_vec(kk) = Exp_protocol_peak_tail_only(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_it, include_Drug_it);

    end

    switch ii
        case 1 %faciliatory drug
            facil_drug_D_var_peak_Cond = peak_Cond_vec;

        case 2 %non-faciliatory drug
            nonfacil_drug_D_var_peak_Cond = peak_Cond_vec;
    end
end

include_Drug_control = 0;
Drug_Model_pars_control = Drug_Model_pars_init;
Drug_Model_pars_control.D = 0; %no drug
norm_Control_noDrug_Cond = Exp_protocol_peak_tail_only(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_control, include_Drug_control);

f_ind_axis_max = ceil(max([facil_drug_D_var_peak_Cond;nonfacil_drug_D_var_peak_Cond])/...
    norm_Control_noDrug_Cond);

figure(1)
p1 = plot(log10(D_vec), nonfacil_drug_D_var_peak_Cond/norm_Control_noDrug_Cond,...
    log10(D_vec), facil_drug_D_var_peak_Cond/norm_Control_noDrug_Cond);

p1(1).Color = 'k';
p1(2).Color = 'r';
xticks(log10(D_vec(1)):1:log10(D_vec(end)));
xlabel('log_{10}([D])', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'normalized peak'; 'open probability'},...
    'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)

ylim([0,f_ind_axis_max]);
yticks(0:1:f_ind_axis_max);
box off
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig7C_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig7C_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend_tag_it = "legend";
        legend('nonfacilitory drug', 'optimal facilitator');
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig7C_peak_O_vs_D_", ...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

%% panel D

mult_factors_interact_vec = 10.^(-2:0.2:2); %vector of possible 
% multiplicative factors when changing both k_on and k_unblock

N_mult_interact = length(mult_factors_interact_vec);

% values of k_on and k_off to be used in simulations
kon_mat = repmat(mult_factors_interact_vec',1, N_mult_interact)*...
    Drug_Model_pars_init.kon;
koff_mat = repmat(mult_factors_interact_vec, N_mult_interact, 1)*...
    Drug_Model_pars_init.koff;

Dkon_mat = Drug_Model_pars_init.D*kon_mat; %[D]*k_on for generating y-axis 
% of plot

peak_Cond_drug_rate_int_mat = zeros(N_mult_interact, N_mult_interact);

parfor ii = 1:N_mult_interact %loop rows of matrices (changing kon)
    kon_vec_it = kon_mat(ii,:);
    koff_vec_it = koff_mat(ii,:);
    
    peak_Cond_drug_rate_int_vec_it = zeros(1, N_mult_interact);

    Drug_Model_pars_it = Drug_Model_pars_init; %initializing Drug model
    %parameters
    
    Drug_Model_pars_it.A = opt_facil_pars.A;
    Drug_Model_pars_it.B = opt_facil_pars.B;

    for jj = 1:N_mult_interact %loop koff
        Drug_Model_pars_it.kon = kon_vec_it(jj); %defining kon
        Drug_Model_pars_it.koff = koff_vec_it(jj); %defining koff

        peak_Cond_drug_rate_int_vec_it(jj) = ...
            Exp_protocol_peak_tail_only(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_it, include_Drug_it);

    end

    peak_Cond_drug_rate_int_mat(ii,:) = peak_Cond_drug_rate_int_vec_it;
    
end

peak_Cond_drug_rate_int_norm_mat = peak_Cond_drug_rate_int_mat/norm_Control_noDrug_Cond;

colormap_drug_max_val = ceil(max(max(peak_Cond_drug_rate_int_norm_mat))*10)/10;

colormap_spacing = 0.01;

n_levels_drug = colormap_drug_max_val/colormap_spacing +1;

custom_drug_colormap1 = repmat(linspace(0, 1, 1/colormap_spacing + 1)', 1, 3);

custom_drug_colormap2 = [ones((colormap_drug_max_val-1)/colormap_spacing + 1, 1),...
    linspace(1, 0, (colormap_drug_max_val-1)/colormap_spacing + 1)',...
    linspace(1, 0, (colormap_drug_max_val-1)/colormap_spacing + 1)'];

custom_drug_colormap = [custom_drug_colormap1;...
    custom_drug_colormap2(2:end,:)];

figure(2)
contourf(log10(koff_mat), log10(Dkon_mat),...
    peak_Cond_drug_rate_int_norm_mat, n_levels_drug, 'LineColor','none');
colormap(custom_drug_colormap);
c = colorbar;
c.Location = "southoutside";

Dkon_lim = [min(min(Dkon_mat)), max(max(Dkon_mat))];
koff_lim = [min(min(koff_mat)), max(max(koff_mat))];

xticks(floor(log10(koff_lim(1))):1:ceil(log10(koff_lim(2))));
xlabel('log_{10}(k_{unblock})', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
yticks(floor(log10(Dkon_lim(1))):1:ceil(log10(Dkon_lim(2))));
ylabel('log_{10}([D]k_{block})', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
xlim(log10(koff_lim));
ylim(log10(Dkon_lim));
box off
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig7D_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig7D_dim);
a.PositionConstraint = 'innerposition';

if(save_paper_figs)
    
    fig_name = strcat(paper_fig_loc, "fig7D_norm_peak_O_as_Dkon_koff_vary_facil_drug");
    
    print(fig_name,'-dpdf')
end

%% O to C3 time constant for comparison to drug binding rates

O_to_C3_rateconstant_neg40 = Adeniran_r_O_to_C3_rateconstant(-40, K_o, Temp);
O_to_C3_rateconstant_neg40_pers = O_to_C3_rateconstant_neg40*1e3; 
%converting rate constant to per second

save("O_to_C3_rateconstant.mat", "O_to_C3_rateconstant_neg40", ...
    "O_to_C3_rateconstant_neg40_pers");