%Steffen Docken
%30-4-23
%This code will run simulations and generate figures based on optimized
%parameters generated in 'Toy_Model_opt'


close all

load('toy_model_params.mat')

%% defining alpha and beta functions
alpha = @(V)toy_model_params.z*exp((V-toy_model_params.p1)/toy_model_params.p2);
beta = @(V)toy_model_params.z*exp((V-toy_model_params.p1)/(-toy_model_params.p2));

alpha_star = @(V)toy_model_params.k*alpha(V);
beta_star = @(V)beta(V);

%defining off rate based on k_on_0 and k_D0 from the global parameters
k_off = k_on_0*k_D0; 

K_D = @(V)(k_off/k_on_0)*(alpha_star(V)./(alpha_star(V) + beta_star(V))).*...
    ((alpha(V) + beta(V))./alpha(V))*1e9; 
% k_on_0 and k_D0 are given in units of Molar in 
% hERG_study_global_params.m. So multiplying by 1e9 nM/M to get K_D in
% terms of nM

V_vec = Act_data(1,1):2:Act_data(end,1);

SS_act_norm_value = alpha(Act_data(Act_data_norm_V_ind, 1))./...
    (alpha(Act_data(Act_data_norm_V_ind, 1)) + ...
    beta(Act_data(Act_data_norm_V_ind, 1))); %value of steady
%state activation from the model fit at the voltage used for experimental 
% actiation data normalization

figure(1)
plot(V_vec, alpha(V_vec)./(alpha(V_vec) + beta(V_vec))/SS_act_norm_value,...
    V_vec, alpha_star(V_vec)./(alpha_star(V_vec) + beta_star(V_vec))/SS_act_norm_value,...
    Act_data(:,1), Act_data(:,2), 'k*');
box off
xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
ylabel({'steady state   '; 'activation   '}, 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
xlim(V_vec([1,end]))
xticks(-80:40:60)
ylim([-0.05,1.05])
yticks(0:0.5:1);
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig2B_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig2B_dim);

for legend_ind = 0:1
    if(legend_ind)
        
        legend('Fit Activation', 'Shifted Activation', 'Data')
        legend_tag_it = "legend";
    else
        legend_tag_it = "no_legend";
    end

    if(save_paper_figs)
        
        fig_name = strcat(paper_fig_loc, "fig2B_", legend_tag_it);
        
        print(fig_name,'-dpdf')
    end
end

figure(2)
p1 = plot(V_vec, K_D(V_vec), 'k');
box off
xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
ylabel('K_d (nM)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
xlim(V_vec([1,end]))
xticks(-80:40:60)
ylim([0, 4100])
yticks(0:2000:4000)
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)

f = gcf; % Get current figure handle
f.Units = fig_units;
f.Position = fig_position(fig2FandG_dim);

a = gca;
a.InnerPosition = axis_innerposition(fig2FandG_dim);

if(save_paper_figs)

    fig_name = strcat(paper_fig_loc, "fig2G");
    
    print(fig_name,'-dpdf')
end

figure(3)
semilogy(V_vec, 1./(alpha(V_vec) + beta(V_vec)),...
    V_vec, 1./(alpha_star(V_vec) + beta_star(V_vec)));
box off
xlabel('voltage (mV)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type)
ylabel('time constant (ms)', 'FontSize',plot_param.font_size, ...
    'FontName',plot_param.font_type);
xlim(V_vec([1,end]))
xticks(-80:40:60)
%ylim([-0.05,1])
yticks(0:0.5:1);
set(gca, 'FontName', plot_param.font_type, ...
    'FontSize', plot_param.font_size, ...
    'TickDir', 'out', ...
    'LineWidth', plot_param.LineWidth)
% if(save_paper_figs)
%     %getting saved export style
%     style_name = 'hERG2023_1';
%     s=hgexport('readstyle', style_name);
%     %applying export style and saving figure
%     fig_name = strcat(paper_fig_loc, "toy_time_const_w_shift.pdf");
%     
%     print(fig_name,'-dpdf')
% end
legend('Fit Time Constant', 'Shifted Time Constant')