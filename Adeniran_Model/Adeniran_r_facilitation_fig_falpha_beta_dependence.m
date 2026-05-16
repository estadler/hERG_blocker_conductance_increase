%Steffen Docken
%9-24-25
%Code to generate output of second Adeniran model figure (panels A and B)

clear
close all

%Experimental Conditions
run("../hERG_study_global_params.m")

f_ind_vec = 10.^(-2:0.02:2); %vector of f_alpha or f_beta values
%when changing independently

N_f_ind = length(f_ind_vec);

%% panel A

Prepulse_flag_it = 1; %prepulse
include_Drug_it = 1; %Drug

for ii = 1:2 %loop f_alpha or f_beta changing
    peak_Cond_vec = zeros(N_f_ind, 1);
    Drug_Model_pars_it = Drug_Model_pars_init; %initializing Drug model
    %parameters
    
    % generating peak conduction vs. f_alpha or f_beta
    for kk = 1:N_f_ind

        switch ii

            case 1 %Drug f_alpha != 1
                Drug_Model_pars_it.A = f_ind_vec(kk); %defining shift in activation
    
            case 2 %Drug with  f_beta != 1
                Drug_Model_pars_it.B = f_ind_vec(kk); %defining shift in deactivation
        end

        peak_Cond_vec(kk) = Exp_protocol_peak_tail_only(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_it, include_Drug_it);

    end

    switch ii
        case 1 %f_alpha shifted
            fa_var_peak_Cond = peak_Cond_vec;

        case 2 %f_beta shifted
            fb_var_peak_Cond = peak_Cond_vec;
    end
end

include_Drug_control = 0;
Drug_Model_pars_control = Drug_Model_pars_init;
Drug_Model_pars_control.D = 0; %no drug
norm_Control_noDrug_Cond = Exp_protocol_peak_tail_only(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_control, include_Drug_control);

f_ind_axis_max = ceil(max([fa_var_peak_Cond;fb_var_peak_Cond])/...
    norm_Control_noDrug_Cond);

figure(1)
p1 = plot(log10(f_ind_vec), fa_var_peak_Cond/norm_Control_noDrug_Cond,...
    log10(f_ind_vec), fb_var_peak_Cond/norm_Control_noDrug_Cond);

p1(1).Color = 'k';
p1(1).LineStyle = "--";
p1(2).Color = 'k';
p1(2).LineStyle = ":";
xticks(-2:1:2);
xlabel('log_{10}(f)', 'FontSize',plot_param.font_size, ...
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
f.Position = fig_position(fig7A_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig7A_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend_tag_it = "legend";
        legend('f_\alpha', 'f_\beta');
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        fig_name = strcat(paper_fig_loc, "fig7A_peak_O_vs_f_facil_drug_", ...
            legend_tag_it);

        print(fig_name,'-dpdf')
    end
end

%% panel B

f_interact_values_vec = 10.^(-2:0.2:2); %vector of f_alpha or f_beta values
%when changing both

N_f_interact = length(f_interact_values_vec);

f_alpha_int_mat = repmat(f_interact_values_vec',1, N_f_interact);
f_beta_int_mat = repmat(f_interact_values_vec, N_f_interact, 1);

peak_Cond_f_int_mat = zeros(N_f_interact, N_f_interact);

parfor ii = 1:N_f_interact %loop rows of matrices (changing f_alpha)
    f_alpha_int_vec_it = f_alpha_int_mat(ii,:);
    f_beta_int_vec_it = f_beta_int_mat(ii,:);
    
    peak_Cond_f_int_vec_it = zeros(1, N_f_interact);

    Drug_Model_pars_it = Drug_Model_pars_init; %initializing Drug model
    %parameters

    for jj = 1:N_f_interact %loop f_beta
        Drug_Model_pars_it.A = f_alpha_int_vec_it(jj); %defining shift in 
        % activation (f_alpha)
        Drug_Model_pars_it.B = f_beta_int_vec_it(jj); %defining shift in 
        % deactivation (f_beta)

        peak_Cond_f_int_vec_it(jj) = ...
            Exp_protocol_peak_tail_only(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_it, include_Drug_it);

    end

    peak_Cond_f_int_mat(ii,:) = peak_Cond_f_int_vec_it;
    
end

peak_Cond_f_int_norm_mat = peak_Cond_f_int_mat/norm_Control_noDrug_Cond;

colormap_max_val = ceil(max(max(peak_Cond_f_int_norm_mat))*10)/10;

colormap_spacing = 0.01;

n_levels = colormap_max_val/colormap_spacing +1;

custom_colormap1 = repmat(linspace(0, 1, 1/colormap_spacing + 1)', 1, 3);

custom_colormap2 = [ones((colormap_max_val-1)/colormap_spacing + 1, 1),...
    linspace(1, 0, (colormap_max_val-1)/colormap_spacing + 1)',...
    linspace(1, 0, (colormap_max_val-1)/colormap_spacing + 1)'];

custom_colormap = [custom_colormap1;...
    custom_colormap2(2:end,:)];

figure(2)
contourf(log10(f_beta_int_mat), log10(f_alpha_int_mat),...
    peak_Cond_f_int_norm_mat, n_levels, 'LineColor','none');
colormap(custom_colormap);
c = colorbar;
c.Location = "southoutside";

xticks(-2:1:2);
xlabel('log_{10}(f_{\beta})', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
yticks(-2:1:2);
ylabel('log_{10}(f_{\alpha})', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);

box off
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out');%, ...
    %'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig7B_dim);

a = f.CurrentAxes;
a.InnerPosition = axis_innerposition(fig7B_dim);
a.PositionConstraint = 'innerposition';

if(save_paper_figs)
    
    fig_name = strcat(paper_fig_loc, "fig7B_norm_peak_O_as_f_alpha_f_beta_vary_facil_drug");
    
    print(fig_name,'-dpdf')
end

