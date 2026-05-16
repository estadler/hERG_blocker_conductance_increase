%Steffen Docken
%9-10-22
%Code to optimize facilitation shifts

close all

%Experimental Conditions
run("../hERG_study_global_params.m")

V_test_vec = -80:2:60; %vector of test potentials

N_V = length(V_test_vec);

for jj = 1:4
    peak_Cond_vec = zeros(N_V, 1);
    switch jj
        case 1
            include_Drug_it = 0; %no Drug
            Prepulse_flag_it = 1; %prepulse
            facilitory_Drug_it = 1; %facilitory params

        case 2
            include_Drug_it = 1; %Drug
            Prepulse_flag_it = 0; %no prepulse
            facilitory_Drug_it = 1; %facilitory params

        case 3
            include_Drug_it = 1; %Drug
            Prepulse_flag_it = 1; %prepulse
            facilitory_Drug_it = 1; %facilitory params

        case 4
            include_Drug_it = 1; %Drug
            Prepulse_flag_it = 1; %prepulse
            facilitory_Drug_it = 0; %non-facilitory params

    end

    % generating peak conduction vs. V
    for kk = 1:N_V
        peak_Cond_vec(kk) = Exp_protocol_peak_tail_only_toy(V_test_vec(kk),...
            Prepulse_flag_it, include_Drug_it, facilitory_Drug_it);

    end

    % time course at opt V
    [~, t_vec, state_timecourse, flux_timecourse, V_timecourse] = Exp_protocol_toy(facil_opt_V,...
            Prepulse_flag_it, include_Drug_it, facilitory_Drug_it);

    switch jj
        case 1 %no Drug
            peak_Cond.noDrug = peak_Cond_vec;

            Opt_V_test_timecourse.noDrug_t = t_vec;
            Opt_V_test_timecourse.noDrug_O = state_timecourse(:, 1);
            Opt_V_test_timecourse.noDrug_C = state_timecourse(:, 4);
            Opt_V_test_timecourse.noDrug_O_star = state_timecourse(:, 2);
            Opt_V_test_timecourse.noDrug_C_star = state_timecourse(:, 3);

            %fluxes (converting from fraction of channels/ms to fraction of
            % channels/s; multiply by 1e3)
            Opt_V_test_timecourse.noDrug_OtoC = flux_timecourse(:,1)*1e3;
            Opt_V_test_timecourse.noDrug_O_startoO = flux_timecourse(:,2)*1e3;
            Opt_V_test_timecourse.noDrug_C_startoO_star = flux_timecourse(:,3)*1e3;

            Opt_V_test_timecourse.noDrug_V_timecourse = V_timecourse;


        case 2 %Drug no Prepulse
            peak_Cond.Drug_noPrepulse = peak_Cond_vec;

            Opt_V_test_timecourse.Drug_noPrepulse_t = t_vec;
            Opt_V_test_timecourse.Drug_noPrepulse_O = state_timecourse(:, 1);
            Opt_V_test_timecourse.Drug_noPrepulse_C = state_timecourse(:, 4);
            Opt_V_test_timecourse.Drug_noPrepulse_O_star = state_timecourse(:, 2);
            Opt_V_test_timecourse.Drug_noPrepulse_C_star = state_timecourse(:, 3);
            
            %fluxes (converting from fraction of channels/ms to fraction of
            % channels/s; multiply by 1e3)
            Opt_V_test_timecourse.Drug_noPrepulse_OtoC = flux_timecourse(:,1)*1e3;
            Opt_V_test_timecourse.Drug_noPrepulse_O_startoO = flux_timecourse(:,2)*1e3;
            Opt_V_test_timecourse.Drug_noPrepulse_C_startoO_star = flux_timecourse(:,3)*1e3;

            Opt_V_test_timecourse.Drug_noPrepulse_V_timecourse = V_timecourse;

        case 3 %Drug with Prepulse
            peak_Cond.Drug_Prepulse = peak_Cond_vec;

            Opt_V_test_timecourse.Drug_Prepulse_t = t_vec;
            Opt_V_test_timecourse.Drug_Prepulse_O = state_timecourse(:, 1);
            Opt_V_test_timecourse.Drug_Prepulse_C = state_timecourse(:, 4);
            Opt_V_test_timecourse.Drug_Prepulse_O_star = state_timecourse(:, 2);
            Opt_V_test_timecourse.Drug_Prepulse_C_star = state_timecourse(:, 3);

            %fluxes (converting from fraction of channels/ms to fraction of
            % channels/s; multiply by 1e3)
            Opt_V_test_timecourse.Drug_Prepulse_OtoC = flux_timecourse(:,1)*1e3;
            Opt_V_test_timecourse.Drug_Prepulse_O_startoO = flux_timecourse(:,2)*1e3;
            Opt_V_test_timecourse.Drug_Prepulse_C_startoO_star = flux_timecourse(:,3)*1e3;

            Opt_V_test_timecourse.Drug_Prepulse_V_timecourse = V_timecourse;
            
        case 4 %non-facilitory drug with Prepulse
            peak_Cond.nonfacil_Drug_Prepulse = peak_Cond_vec;

            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_t = t_vec;
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_O = state_timecourse(:, 1);
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_C = state_timecourse(:, 4);
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_O_star = state_timecourse(:, 2);
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_C_star = state_timecourse(:, 3);

            %fluxes (converting from fraction of channels/ms to fraction of
            % channels/s; multiply by 1e3)
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_OtoC = flux_timecourse(:,1)*1e3;
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_O_startoO = flux_timecourse(:,2)*1e3;
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_C_startoO_star = flux_timecourse(:,3)*1e3;
    
            Opt_V_test_timecourse.nonfacil_Drug_Prepulse_V_timecourse = V_timecourse;

    end
    
    jj

end

%% fig 1
figure(1)
p1 = plot(Opt_V_test_timecourse.noDrug_t, Opt_V_test_timecourse.noDrug_O,...
    Opt_V_test_timecourse.nonfacil_Drug_Prepulse_t, Opt_V_test_timecourse.nonfacil_Drug_Prepulse_O,...
    Opt_V_test_timecourse.Drug_Prepulse_t, Opt_V_test_timecourse.Drug_Prepulse_O);
box off
p1(1).Color = plot_param.plot_colors{plot_param.with_prepulse,...
    plot_param.no_nifekalant, plot_param.State_occ};
p1(2).Color = plot_param.plot_colors{plot_param.no_prepulse,...
    plot_param.nifekalant, plot_param.State_occ};
p1(3).Color = plot_param.plot_colors{plot_param.with_prepulse,...
    plot_param.nifekalant, plot_param.State_occ};
xlim([0, 20e3]);
%xlabel('')
%ylabel('')
%hold on
%plot([15e3, 16e3], [0, 0], 'k') %adding scale bar
%hold off

%set(gca, 'XColor', 'k', 'YColor', 'k')
xticks(0:5e3:20e3);
xticklabels(0:5:20);
yticks(0:0.1:1);
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('open probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)%, ...
    %'XColor', 'none', ...
    %'YColor', 'none')

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig2Cmain_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig2Cmain_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'non-facilitory drug', 'facilitory drug');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig2C_", legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

norm_Control_noDrug_Cond = peak_Cond.noDrug(V_test_vec == V_norm);
%peak tail current from control protocol at test voltage used for
%normalization

noDrug_V_opt_Cond = peak_Cond.noDrug(V_test_vec == facil_opt_V);
%peak tail current from no drug protocol at facilitation optimization test
%voltage

%% fig 2
figure(2)
p1 = plot(Opt_V_test_timecourse.noDrug_t, Opt_V_test_timecourse.noDrug_O/noDrug_V_opt_Cond,...
    Opt_V_test_timecourse.nonfacil_Drug_Prepulse_t, Opt_V_test_timecourse.nonfacil_Drug_Prepulse_O/noDrug_V_opt_Cond,...
    Opt_V_test_timecourse.Drug_Prepulse_t, Opt_V_test_timecourse.Drug_Prepulse_O/noDrug_V_opt_Cond);
box off
p1(1).Color = plot_param.plot_colors{plot_param.with_prepulse,...
    plot_param.no_nifekalant, plot_param.State_occ};
p1(2).Color = plot_param.plot_colors{plot_param.no_prepulse,...
    plot_param.nifekalant, plot_param.State_occ};
p1(3).Color = plot_param.plot_colors{plot_param.with_prepulse,...
    plot_param.nifekalant, plot_param.State_occ};
xlim([14.5e3, 19e3]);
ylim([0, 2.7]);
%xlabel('')
%ylabel('')
%hold on
%plot([15e3, 16e3], [0, 0], 'k') %adding scale bar
%hold off
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)%, ...
    %'XColor', 'none', ...
    %'YColor', 'none')
%set(gca, 'XColor', 'k', 'YColor', 'k')
xticks(15e3:1e3:19e3);
xticklabels(15:19);
yticks(0:0.5:2.5);
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'normalized open'; 'probability'}, 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig2Cinset_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig2Cinset_dim);

for legend_ind = 0:1
    if(legend_ind)
        legend('no drug', 'non-facilitory drug', 'facilitory drug');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig2C_inset_", legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end



%% fig 3
figure(3)
p1 = plot(V_test_vec, peak_Cond.noDrug/norm_Control_noDrug_Cond,...
    V_test_vec, peak_Cond.Drug_noPrepulse/norm_Control_noDrug_Cond,...
    V_test_vec, peak_Cond.Drug_Prepulse/norm_Control_noDrug_Cond);
box off
p1(1).Color = plot_param.plot_colors{plot_param.with_prepulse,...
    plot_param.no_nifekalant, plot_param.Current_GV};
p1(2).Color = plot_param.plot_colors{plot_param.no_prepulse,...
    plot_param.nifekalant, plot_param.Current_GV};
p1(3).Color = plot_param.plot_colors{plot_param.with_prepulse,...
    plot_param.nifekalant, plot_param.Current_GV};


set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

for legend_ind = 0:1
    if(legend_ind)
        
        legend('no drug', 'facilitory drug w/ no prepulse', 'facilitory drug w/ prepulse');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    for inset_ind = 0:1

        if(inset_ind)
            xlim([-60, -20]);
            xticks(-60:20:-20);
            ylim([0,.3])
            yticks([0, 0.3]);
            %xlabel('')
            %ylabel('')
            
            xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
                'FontName',plot_param.font_type);
            ylabel({'normalized peak'; 'open probability'}, 'FontSize',plot_param.font_size, ...
                'FontName',plot_param.font_type)

            inset_tag_it = "inset_";

        else
            xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
                'FontName',plot_param.font_type);
            ylabel({'normalized peak'; 'open probability'}, 'FontSize',plot_param.font_size, ...
                'FontName',plot_param.font_type);
            xlim([min(V_test_vec), max(V_test_vec)]);
            xticks(-80:20:60);
            ylim([0, 1.15]);
            yticks(0:0.2:1);

            inset_tag_it = "";
        end

        f = gcf; % Get current figure handle
        f.Units = fig_units;
        f.Position = fig_position(fig2D_dim);
            
        a = gca;
        a.InnerPosition = axis_innerposition(fig2D_dim);

        if(save_paper_figs)

            fig_name = strcat(paper_fig_loc, "fig2D_", inset_tag_it, ...
                legend_tag_it);
            
            print(fig_name,'-dpdf')
        end

    end
end


%% fig 4
flux_vec_ind = find((Opt_V_test_timecourse.Drug_Prepulse_t < 19e3)&...
    (Opt_V_test_timecourse.Drug_Prepulse_t >= 14.5e3));
figure(4)
p1 = plot(Opt_V_test_timecourse.Drug_Prepulse_t(flux_vec_ind), ...
    Opt_V_test_timecourse.Drug_Prepulse_OtoC(flux_vec_ind), 'k-',...
    Opt_V_test_timecourse.Drug_Prepulse_t(flux_vec_ind), ...
    Opt_V_test_timecourse.Drug_Prepulse_O_startoO(flux_vec_ind), 'k--');
box off
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel({'flux (fraction'; 'channels/s)'}, 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
xlim([14.5e3, 19e3]);
xticks(15e3:1e3:19e3);
xticklabels(15:19);
ylim([-3e-2, 8.5e-2])
yticks(-2e-2:2e-2:8e-2);

set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig2E_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig2E_dim);


for legend_ind = 0:1
    if(legend_ind)
        
        legend('O -> C', 'O* -> O')
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig2E_", legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end


%% fig 5
figure(5)
p1 = plot(Opt_V_test_timecourse.Drug_Prepulse_t, Opt_V_test_timecourse.Drug_Prepulse_C,...
    Opt_V_test_timecourse.Drug_Prepulse_t, Opt_V_test_timecourse.Drug_Prepulse_C_star);
box off
xlim([0, 20e3]);
%xlabel('')
%ylabel('')
%hold on
%plot([15e3, 16e3], [0, 0], 'k') %adding scale bar
%hold off

%set(gca, 'XColor', 'k', 'YColor', 'k')
xticks(0:5e3:20e3);
xticklabels(0:5:20);
yticks(0:0.1:1);
xlabel('time (s)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
ylabel('probability', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)%, ...
    %'XColor', 'none', ...
    %'YColor', 'none')

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig2FandG_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig2FandG_dim);

for legend_ind = 0:1
    if(legend_ind)
        
        legend('C', 'C*');
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end
    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig2F_", legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end


%set(gca, 'XColor', 'k', 'YColor', 'k')
xlim([14.5e3, 20e3]);
xticks(15e3:1e3:20e3);
xticklabels(15:20);
yticks(0:0.1:1);

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig2FandG_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig2FandG_dim);

for legend_ind = 0:1
    if(legend_ind)
        
        legend('C', 'C*');
        legend_tag_it = "legend";
    else
        legend('off')
        legend_tag_it = "no_legend";
    end
    
    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig2F_inset_", legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

%% fig 6 confirming V timecourse of protocol
figure(6)
subplot(2,2,1)
plot(Opt_V_test_timecourse.noDrug_t, Opt_V_test_timecourse.noDrug_V_timecourse);
title('No Drug')
ylabel('V (mV)')
xlabel('time (ms)')

subplot(2,2,2)
plot(Opt_V_test_timecourse.nonfacil_Drug_Prepulse_t, Opt_V_test_timecourse.nonfacil_Drug_Prepulse_V_timecourse);
title('Non-facilitory Drug')
ylabel('V (mV)')
xlabel('time (ms)')

subplot(2,2,3)
plot(Opt_V_test_timecourse.Drug_Prepulse_t, Opt_V_test_timecourse.Drug_Prepulse_V_timecourse);
title('Drug w/ Prepulse')
ylabel('V (mV)')
xlabel('time (ms)')

subplot(2,2,4)
plot(Opt_V_test_timecourse.Drug_noPrepulse_t, Opt_V_test_timecourse.Drug_noPrepulse_V_timecourse);
title('Drug w/ no Prepulse')
ylabel('V (mV)')
xlabel('time (ms)')

