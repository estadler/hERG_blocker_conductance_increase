%Steffen Docken
%1-4-26
%Code for time constant of C3 to O transition as described by the system of differential equations for
%the reduced hERG model in Adeniran et al. 2011 with no drug. In the original paper, the
% model was fit to data at physiological temperater (37C), so that is what
% the baseline parameters here represent.

function O_to_C3_rateconstant = Adeniran_r_O_to_C3_rateconstant(V, Ko, Temp)

%Q10 factors are from Vandenberg et al. 2006
Q10_A = 2.1;
Q10_DeA = 1.7;
Q10_I = 2.5;
Q10_ReI = 2.6;

Tfactor_A = Q10_A^((Temp - 310)/10); %temperature factor for activation
Tfactor_DeA = Q10_DeA^((Temp - 310)/10); %temperature factor for deactivation
Tfactor_I = Q10_I^((Temp - 310)/10); %temperature factor for inactivation
Tfactor_ReI = Q10_ReI^((Temp - 310)/10); %temperature factor for 
%recovery from inactivation


%a1 = 2.172*Tfactor_A; %ms^-1
%b1 = 1.077*Tfactor_DeA;%ms^-1 %unneeded

%a2 = (6.55e-3)*exp(0.027735765*(V - 36))*Tfactor_A;%ms^-1
b2 = (1.908205e-3)*exp(-0.0148902*V)*Tfactor_DeA;%ms^-1

%ai = (4.829e-2)*exp(-0.039984*(V + 25))*4.5/Ko*Tfactor_ReI;%ms^-1
%bi = 0.2624*exp(0.000942*V)*(4.5/Ko)^0.3*Tfactor_I;%ms^-1 %unneeded

%a = (5.55e-3)*exp(0.05547153*(V - 12))*Tfactor_A;%ms^-1
%b = (2.357e-3)*exp(-0.036588*V)*Tfactor_DeA;%ms^-1 %unneeded

%% differential equations; for reference regarding time constant
%dC1 = b*C2 - a*C1; %Not needed, because C1 is calculated as 1-sum of all
%other states by conservation of proportion
%dC2 = a*C1 + b1*C3 - (b + a1)*C2;
%dC3 = a1*C2 + b2*O - (b1 + a2)*C3;
%dO = a2*C3 + ai*I - (b2 + bi)*O;
%dI = bi*O - (ai)*I;

O_to_C3_rateconstant = b2; %ms^-1