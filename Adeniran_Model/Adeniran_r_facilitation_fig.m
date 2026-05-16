%Steffen Docken
%9-10-22
%Code to generate output of first Adeniran model figure (panels B to E)

clear
close all

%Experimental Conditions
run("../hERG_study_global_params.m")

V_test_vec = -70:2:40; %vector of test potentials

N_V = length(V_test_vec);


%% panels C to E

Prepulse_flag_it = 1; %prepulse

for jj = 1:4
    peak_Cond_vec = zeros(N_V, 1);

    Drug_Model_pars_it = Drug_Model_pars_init; %initializing Drug model
    %parameters
    switch jj
        case 1 %no drug
            include_Drug_it = 0; %no Drug
            Drug_Model_pars_it.D = 0; %no drug

        case 2 %drug with no shift in rates
            include_Drug_it = 1; %Drug

        case 3 %Drug with 10 fold increase in f_alpha
            include_Drug_it = 1; %Drug
            Drug_Model_pars_it.A = 10;

        case 4 %Drug with 10 fold decrease in f_beta
            include_Drug_it = 1; %Drug
            Drug_Model_pars_it.B = 0.1;
    end

    % generating peak conduction vs. V
    for kk = 1:N_V
        peak_Cond_vec(kk) = Exp_protocol_peak_tail_only(V_test_vec(kk),...
            Prepulse_flag_it, Drug_Model_pars_it, include_Drug_it);

    end

    % time course at opt V (-40 mV)
    [~, t_vec, state_timecourse, flux_timecourse] = Exp_protocol(facil_opt_V,...
            Prepulse_flag_it, Drug_Model_pars_it, include_Drug_it);

    switch jj
        case 1 %no Drug
            noDrug.peak_Cond = peak_Cond_vec;

            noDrug.t = t_vec;
            noDrug.O = state_timecourse(:, Ind.O);
            noDrug.flux_C3toO = flux_timecourse(:, 3);
            noDrug.flux_ItoO = flux_timecourse(:, 4);
            noDrug.flux_DOtoO = flux_timecourse(:, 5);
            noDrug.OnI = sum(state_timecourse(:, [Ind.O, Ind.I]),2);
            noDrug.DOnDI = sum(state_timecourse(:, [Ind.DO, Ind.DI]),2);

        case 2 %drug with no shift in rates
            drug_no_shift.peak_Cond = peak_Cond_vec;

            drug_no_shift.t = t_vec;
            drug_no_shift.O = state_timecourse(:, Ind.O);
            drug_no_shift.flux_C3toO = flux_timecourse(:, 3);
            drug_no_shift.flux_ItoO = flux_timecourse(:, 4);
            drug_no_shift.flux_DOtoO = flux_timecourse(:, 5);
            drug_no_shift.OnI = sum(state_timecourse(:, [Ind.O, Ind.I]),2);
            drug_no_shift.DOnDI = sum(state_timecourse(:, [Ind.DO, Ind.DI]),2);

        case 3 %Drug with 10 fold increase in f_alpha
            drug_fa10.peak_Cond = peak_Cond_vec;

            drug_fa10.t = t_vec;
            drug_fa10.O = state_timecourse(:, Ind.O);
            drug_fa10.flux_C3toO = flux_timecourse(:, 3);
            drug_fa10.flux_ItoO = flux_timecourse(:, 4);
            drug_fa10.flux_DOtoO = flux_timecourse(:, 5);
            drug_fa10.OnI = sum(state_timecourse(:, [Ind.O, Ind.I]),2);
            drug_fa10.DOnDI = sum(state_timecourse(:, [Ind.DO, Ind.DI]),2);
            drug_fa10.D_states = ...
                sum(state_timecourse(:, [Ind.DC1, Ind.DC2, Ind.DC3, ...
                Ind.DO, Ind.DI]), 2);

        case 4 %Drug with 10 fold decrease in f_beta
            drug_fb0p1.peak_Cond = peak_Cond_vec;

            drug_fb0p1.t = t_vec;
            drug_fb0p1.O = state_timecourse(:, Ind.O);
            drug_fb0p1.flux_C3toO = flux_timecourse(:, 3);
            drug_fb0p1.flux_ItoO = flux_timecourse(:, 4);
            drug_fb0p1.flux_DOtoO = flux_timecourse(:, 5);
            drug_fb0p1.OnI = sum(state_timecourse(:, [Ind.O, Ind.I]),2);
            drug_fb0p1.DOnDI = sum(state_timecourse(:, [Ind.DO, Ind.DI]),2);
            drug_fb0p1.D_states = ...
                sum(state_timecourse(:, [Ind.DC1, Ind.DC2, Ind.DC3, ...
                Ind.DO, Ind.DI]), 2);
    end

end

%% all time courses
figure(1)
subplot(2,2,1)
plot(noDrug.t, noDrug.O, noDrug.t, noDrug.DOnDI, noDrug.t, noDrug.OnI);
title('No Drug')
legend('O', 'O* and I*', 'O and I')

subplot(2,2,2)
plot(drug_no_shift.t, drug_no_shift.O, drug_no_shift.t, drug_no_shift.DOnDI,...
    drug_no_shift.t, drug_no_shift.OnI);
title('Drug with no shift')

subplot(2,2,3)
plot(drug_fa10.t, drug_fa10.O, drug_fa10.t, drug_fa10.DOnDI, ...
    drug_fa10.t, drug_fa10.OnI);
title('Drug with f_\alpha shifted by 10')

subplot(2,2,4)
plot(drug_fb0p1.t, drug_fb0p1.O, drug_fb0p1.t, drug_fb0p1.DOnDI, ...
    drug_fb0p1.t, drug_fb0p1.OnI);
title('Drug with f_\beta shifted by 0.1')

%%
norm_Control_noDrug_Cond = noDrug.peak_Cond(V_test_vec == V_norm);
%peak tail current from control protocol at test voltage used for
%normalization

max_O = max([noDrug.O(noDrug.t >14e3); ...
    drug_no_shift.O(drug_no_shift.t > 14e3); ...
    drug_fa10.O(drug_fa10.t > 14e3);...
    drug_fb0p1.O(drug_fb0p1.t >14e3)]);
max_O_axis = 1.05*max_O;

O_last_tick = floor(max_O_axis/0.005)*0.005;

%% panel C
%left plot
figure(2)
p1 = plot(noDrug.t, noDrug.O,...
    drug_no_shift.t, drug_no_shift.O);
box off
p1(1).Color = 'k';
p1(2).Color = [0.7, 0.7, 0.7];
xlim([14.5e3, 20e3]);
xticks(15e3:1e3:20e3);
xticklabels(15:20);
ylim([0, max_O_axis]);
yticks(0:0.005:O_last_tick);
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('open probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth);


f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig6CtoE_left_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig6CtoE_left_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'f_\alpha = f_\beta = 1');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end
    
    if(save_paper_figs)
        fig_name = strcat(paper_fig_loc, "fig6C_left_O_timecourse_nonfacil_drug_",...
            legend_tag_it);
        
        print(fig_name,'-dpdf')

    end
end

%right plot
figure(3)
p2 = plot(V_test_vec, noDrug.peak_Cond,...
    V_test_vec, drug_no_shift.peak_Cond);

p2(1).Color = 'k';
p2(2).Color = [0.7, 0.7, 0.7];
xticks(-60:20:40);
xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'normalized peak'; 'open probability'},...
    'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)

yyaxis right
p3 = semilogy(V_test_vec, drug_no_shift.peak_Cond./noDrug.peak_Cond, ...
    "LineStyle",":");

p3(1).Color = [0.7, 0.7, 0.7];
xlim([-70, 40]);
ax = gca();
ax.YAxis(2).Color = [0, 0, 0];
ax.YAxis(1).Limits = [0, 0.5];
ax.YAxis(1).TickValues = 0:0.1:0.5;
ax.YAxis(2).Limits = [1e-1, 1e2];
ax.YAxis(2).TickValues = [1e-1, 1, 1e1, 1e2];
ylabel('drug/no drug', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
box off
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)


f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig6CtoE_right_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig6CtoE_right_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'f_\alpha = f_\beta = 1', 'drug/no drug');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig6C_right_peak_O_vs_V_nonfacil_drug_",...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

%% panel D
%left plot
figure(4)
p1 = plot(noDrug.t, noDrug.O,...
    drug_fa10.t, drug_fa10.O);
box off
p1(1).Color = 'k';
p1(2).Color = 'r';
xlim([14.5e3, 20e3]);
xticks(15e3:1e3:20e3);
xticklabels(15:20);
ylim([0, max_O_axis]);
yticks(0:0.005:O_last_tick);
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
f.Position = fig_position(fig6CtoE_left_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig6CtoE_left_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'f_\alpha = 10');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig6D_left_O_timecourse_falpha10_drug_",...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

%right plot
figure(5)
p2 = plot(V_test_vec, noDrug.peak_Cond,...
    V_test_vec, drug_fa10.peak_Cond);

p2(1).Color = 'k';
p2(2).Color = 'r';
xticks(-60:20:40);
xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'normalized peak'; 'open probability'},...
    'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)

yyaxis right
p3 = semilogy(V_test_vec, drug_fa10.peak_Cond./noDrug.peak_Cond, ...
    "LineStyle",":");

p3(1).Color = 'r';
xlim([-70, 40]);
ax = gca();
ax.YAxis(2).Color = [0, 0, 0];
ax.YAxis(1).Limits = [0, 0.5];
ax.YAxis(1).TickValues = 0:0.1:0.5;
ax.YAxis(2).Limits = [1e-1,1e2];
ax.YAxis(2).TickValues = [1e-1, 1, 1e1, 1e2];
ylabel('drug/no drug', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
box off
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig6CtoE_right_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig6CtoE_right_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'f_\alpha = 10', 'drug/no drug');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig6D_right_peak_O_vs_V_falpha10_drug_", ...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

%% panel E
%left plot
figure(6)
p1 = plot(noDrug.t, noDrug.O,...
    drug_fb0p1.t, drug_fb0p1.O);
box off
p1(1).Color = 'k';
p1(2).Color = 'r';
xlim([14.5e3, 20e3]);
xticks(15e3:1e3:20e3);
xticklabels(15:20);
ylim([0, max_O_axis]);
yticks(0:0.005:O_last_tick);
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
f.Position = fig_position(fig6CtoE_left_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig6CtoE_left_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'f_\beta = 0.1');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig6E_left_O_timecourse_fbeta0p1_drug_", ...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

%right plot
figure(7)
p2 = plot(V_test_vec, noDrug.peak_Cond,...
    V_test_vec, drug_fb0p1.peak_Cond);


p2(1).Color = 'k';
p2(2).Color = 'r';
xticks(-60:20:40);
xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'normalized peak'; 'open probability'},...
    'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)

yyaxis right
p3 = semilogy(V_test_vec, drug_fb0p1.peak_Cond./noDrug.peak_Cond, ...
    "LineStyle",":");

p3(1).Color = 'r';
xlim([-70, 40]);
ax = gca();
ax.YAxis(2).Color = [0, 0, 0];
ax.YAxis(1).Limits = [0, 0.5];
ax.YAxis(1).TickValues = 0:0.1:0.5;
ax.YAxis(2).Limits = [1e-1, 1e2];
ax.YAxis(2).TickValues = [1e-1, 1, 1e1, 1e2];
ylabel('drug/no drug', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
box off
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig6CtoE_right_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig6CtoE_right_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'f_\beta = 0.1', 'drug/no drug');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig6E_right_peak_O_vs_V_fbeta0p1_drug_", ...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end


%% panel B
figure(8)
p1 = plot(drug_fa10.t, drug_fa10.D_states,...
    drug_fb0p1.t, drug_fb0p1.D_states);
box off
p1(1).Color = 'r';
p1(1).LineStyle = "--";
p1(2).Color = 'r';
p1(2).LineStyle = ":";
xlim([0, 15e3]);
xticks(0:5e3:15e3);
xticklabels(0:15);
ylim([0, 0.5]);
yticks([0,0.5]);
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('block probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig6B_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig6B_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('f_\alpha = 10', 'f_\beta = 0.1');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig6B_block_timecourse_falpha10_fbeta0p1_drug_", ...
            legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end