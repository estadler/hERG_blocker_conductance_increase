%Steffen Docken
%10-06-25
%Code to visualize time course of hERG channel occupancy protocol

clear
close all

%Experimental Conditions
run("../hERG_study_global_params.m")

%optimal faciliation factors
load Opt_facil_params.mat

inset_range = [15e3, 19e3]; %range of t values for insets
inset_tick_labels = 15:19;

%% protocol simulations

Prepulse_flag_it = 1; %prepulse

for jj = 1:2

    Drug_Model_pars_it = Drug_Model_pars_init; %initializing Drug model
    %parameters
    switch jj
        case 1 %no drug
            include_Drug_it = 0; %no Drug
            Drug_Model_pars_it.D = 0; %no drug
            %if jj == 1, A and B are left as 1 (as in Drug_Model_pars_init)

        case 2 %drug with optimal shift
            include_Drug_it = 1; %Drug
            %faciliatory drug
            Drug_Model_pars_it.A = opt_facil_pars.A;
            Drug_Model_pars_it.B = opt_facil_pars.B;

            %if jj == 2, D is left as in Drug_Model_pars_init
    end

    % time course at opt V (-40 mV)
    [~, t_vec, state_timecourse, flux_timecourse] = Exp_protocol(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_it, include_Drug_it);

    switch jj
        case 1 %no Drug

            noDrug.t = t_vec;
            noDrug.O = state_timecourse(:, Ind.O);
            noDrug.I = state_timecourse(:, Ind.I);
            noDrug.blocked = ...
                sum(state_timecourse(:, [Ind.DC1, Ind.DC2, Ind.DC3,...
                Ind.DO, Ind.DI]),2);
            noDrug.C = ...
                sum(state_timecourse(:, [Ind.C1, Ind.C2, Ind.C3]),2);
            %fluxes (converting from fraction of channels/ms to fraction of
            % channels/s; multiply by 1e3)
            noDrug.flux_DC3toDO = flux_timecourse(:, 9)*1e3; 
            noDrug.flux_DO_DItoO_I = sum(flux_timecourse(:, [5, 6]), 2)*1e3;
            noDrug.flux_OtoC3 = -flux_timecourse(:, 3)*1e3;

        case 2 %drug with optimal facilitation
            opt_facil.t = t_vec;
            opt_facil.O = state_timecourse(:, Ind.O);
            opt_facil.I = state_timecourse(:, Ind.I);
            opt_facil.blocked = ...
                sum(state_timecourse(:, [Ind.DC1, Ind.DC2, Ind.DC3,...
                Ind.DO, Ind.DI]),2);
            opt_facil.C = ...
                sum(state_timecourse(:, [Ind.C1, Ind.C2, Ind.C3]),2);

            %fluxes (converting from fraction of channels/ms to fraction of
            % channels/s; multiply by 1e3)
            opt_facil.flux_DC3toDO = flux_timecourse(:, 9)*1e3;
            opt_facil.flux_DO_DItoO_I = sum(flux_timecourse(:, [5, 6]), 2)*1e3;
            opt_facil.flux_OtoC3 = -flux_timecourse(:, 3)*1e3;

    end

end


%% panel A (Open state)
figure(1)
p1 = plot(noDrug.t, noDrug.O,...
    opt_facil.t, opt_facil.O);
box off
p1(1).Color = 'k';
p1(2).Color = 'r';

xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('open probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig8AtoD_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig8AtoD_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', strcat('f_\alpha = ', num2str(opt_facil_pars.A, 2),...
            ', f_\beta = ', num2str(opt_facil_pars.B, 2)));
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    for inset_ind = 0:1
        if(inset_ind)
            xlim([inset_range(1), inset_range(2)]);
            xticks(inset_range(1):1e3:inset_range(2));
            xticklabels(inset_tick_labels);
            max_O_inset = max([noDrug.O((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)));...
                opt_facil.O((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)))]);
            ylim_O_inset = ceil(max_O_inset/0.01)*0.01;
            ylim([0, ylim_O_inset]);

            inset_tag_it = "_inset";
        else

            xlim([0, 20e3]);
            xticks(0:5e3:20e3);
            xticklabels(0:5:20);
            ylim([0, 1]);

            inset_tag_it = "";
        end

        if(save_paper_figs)

            fig_name = strcat(paper_fig_loc, "fig8A_O_timecourse_opt_facil_drug_",...
                legend_tag_it, inset_tag_it);

            print(fig_name,'-dpdf')
        end
    end
end


%% panel B (Inactivated state)
figure(2)
p1 = plot(noDrug.t, noDrug.I,...
    opt_facil.t, opt_facil.I);
box off
p1(1).Color = 'k';
p1(2).Color = 'r';

xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('inactivated probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig8AtoD_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig8AtoD_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', strcat('f_\alpha = ', num2str(opt_facil_pars.A, 2),...
            ', f_\beta = ', num2str(opt_facil_pars.B, 2)));
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    for inset_ind = 0:1
        if(inset_ind)
            xlim([inset_range(1), inset_range(2)]);
            xticks(inset_range(1):1e3:inset_range(2));
            xticklabels(inset_tick_labels);
            max_I_inset = max([noDrug.I((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)));...
                opt_facil.I((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)))]);
            ylim_I_inset = ceil(max_I_inset/0.01)*0.01;
            ylim([0, ylim_I_inset]);

            inset_tag_it = "_inset";

        else
            xlim([0, 20e3]);
            xticks(0:5e3:20e3);
            xticklabels(0:5:20);
            ylim([0, 1]);
            %yticks(0::O_last_tick);

            inset_tag_it = "";
        end

        if(save_paper_figs)
            
            fig_name = strcat(paper_fig_loc, "fig8B_I_timecourse_opt_facil_drug_",...
                legend_tag_it, inset_tag_it);
            
            print(fig_name,'-dpdf')
        end
    end
end


%% panel C (Blocked states)
figure(3)
p1 = plot(noDrug.t, noDrug.blocked,...
    opt_facil.t, opt_facil.blocked);
box off
p1(1).Color = 'k';
p1(2).Color = 'r';

xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('blocked probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig8AtoD_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig8AtoD_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', strcat('f_\alpha = ', num2str(opt_facil_pars.A, 2),...
            ', f_\beta = ', num2str(opt_facil_pars.B, 2)));
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    for inset_ind = 0:1
        if(inset_ind)
            xlim([inset_range(1), inset_range(2)]);
            xticks(inset_range(1):1e3:inset_range(2));
            xticklabels(inset_tick_labels);
            max_blocked_inset = max([noDrug.blocked((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)));...
                opt_facil.blocked((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)))]);
            ylim_blocked_inset = ceil(max_blocked_inset/0.1)*0.1;
            ylim([0, ylim_blocked_inset]);

            inset_tag_it = "_inset";
        else
            xlim([0, 20e3]);
            xticks(0:5e3:20e3);
            xticklabels(0:5:20);
            ylim([0, 1]);
            %yticks(0::O_last_tick);

            inset_tag_it = "";
        end


        if(save_paper_figs)

            fig_name = strcat(paper_fig_loc, "fig8C_blocked_timecourse_opt_facil_drug_",...
                legend_tag_it, inset_tag_it);
            
            print(fig_name,'-dpdf')
        end
    end
end

%% panel D (Closed states)
figure(4)
p1 = plot(noDrug.t, noDrug.C,...
    opt_facil.t, opt_facil.C);
box off
p1(1).Color = 'k';
p1(2).Color = 'r';

xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('closed probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig8AtoD_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig8AtoD_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', strcat('f_\alpha = ', num2str(opt_facil_pars.A, 2),...
            ', f_\beta = ', num2str(opt_facil_pars.B, 2)));
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    for inset_ind = 0:1

        if(inset_ind)
            xlim([inset_range(1), inset_range(2)]);
            xticks(inset_range(1):1e3:inset_range(2));
            xticklabels(inset_tick_labels);
            max_closed_inset = max([noDrug.C((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)));...
                opt_facil.C((noDrug.t >=inset_range(1))&(noDrug.t <= inset_range(2)))]);
            ylim_closed_inset = ceil(max_closed_inset/0.1)*0.1;
            ylim([0, ylim_closed_inset]);

            inset_tag_it = "_inset";
        else
            xlim([0, 20e3]);
            xticks(0:5e3:20e3);
            xticklabels(0:5:20);
            ylim([0, 1]);
            %yticks(0::O_last_tick);

            inset_tag_it = "";
        end

        if(save_paper_figs)
            
            fig_name = strcat(paper_fig_loc, "fig8D_closed_timecourse_opt_facil_drug_",...
                legend_tag_it, inset_tag_it);
            
            print(fig_name,'-dpdf')
        end
    end
end


%% panel E (unbinding flux)
flux_ind = find((opt_facil.t >=inset_range(1))&(opt_facil.t < inset_range(2)));
%not including last time point as it corresponds to a different voltage, so
%there is a discontinuity in the flux curves.

figure(5)
p1 = plot(opt_facil.t(flux_ind), opt_facil.flux_DC3toDO(flux_ind));
box off
p1(1).Color = 'r';
p1(1).LineStyle = ":";
xlim([inset_range(1), inset_range(2)]);
xticks(inset_range(1):1e3:inset_range(2));
xticklabels(inset_tick_labels);
ylim([0, 2.75]);
yticks(0:2);
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'flux (fraction'; 'channels/s)'}, 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig8Epanels_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig8Epanels_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('C3* to O*');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig8E_top_channel_bound_activate_state_flux_timecourse_opt_facil_drug_",...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end


figure(6)
p1 = plot(opt_facil.t(flux_ind), opt_facil.flux_DO_DItoO_I(flux_ind),...
    opt_facil.t(flux_ind), opt_facil.flux_OtoC3(flux_ind));
box off
p1(1).Color = 'r';
p1(1).LineStyle = "--";
p1(2).Color = 'k';
p1(2).LineStyle = "-";
xlim([inset_range(1), inset_range(2)]);
xticks(inset_range(1):1e3:inset_range(2));
xticklabels(inset_tick_labels);
ylim([0, 0.2]);
yticks([0,0.1, 0.2]);
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'flux (fraction'; 'channels/s)'}, 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig8Epanels_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig8Epanels_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('(O* to O) + (I* to I)', 'O to C3');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig8E_bottom_channel_unbind_close_state_flux_timecourse_opt_facil_drug_",...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end
