%Steffen Docken
%5-20-18
%Code for the Right Hand Side of the system of differential equations for
%the reduced hERG model in Adeniran et al. 2011. In the original paper, the
% model was fit to data at physiological temperater (37C), so that is what
% the baseline parameters here represent.

function dX = Adeniran_r_drug_RHS(~ ,X , V, Ko, Drug_Model_pars, Temp)

%drug binding rate constant
Dkon = Drug_Model_pars.D*Drug_Model_pars.kon;

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

C1 = 1 - sum(X);
C2 = X(1);
C3 = X(2);
O = X(3);
I = X(4);

DC1 = X(5);
DC2 = X(6);
DC3 = X(7);
DO = X(8);
DI = X(9);

a1 = 2.172*Tfactor_A; %ms^-1
b1 = 1.077*Tfactor_DeA;%ms^-1

a2 = (6.55e-3)*exp(0.027735765*(V - 36))*Tfactor_A;%ms^-1
b2 = (1.908205e-3)*exp(-0.0148902*V)*Tfactor_DeA;%ms^-1

ai = (4.829e-2)*exp(-0.039984*(V + 25))*4.5/Ko*Tfactor_ReI;%ms^-1
bi = 0.2624*exp(0.000942*V)*(4.5/Ko)^0.3*Tfactor_I;%ms^-1

a = (5.55e-3)*exp(0.05547153*(V - 12))*Tfactor_A;%ms^-1
b = (2.357e-3)*exp(-0.036588*V)*Tfactor_DeA;%ms^-1

%rates for drug-bound states. All are actiavtion or deactivation rates are
%shifted the same
Da = Drug_Model_pars.A*a;
Db = Drug_Model_pars.B*b;

Da1 = Drug_Model_pars.A*a1;
Db1 = Drug_Model_pars.B*b1;

Da2 = Drug_Model_pars.A*a2;
Db2 = Drug_Model_pars.B*b2;

%dC1 = b*C2 - a*C1; %Not needed, because C1 is calculated as 1-sum of all
%other states by conservation of proportion
dC2 = a*C1 + b1*C3 - (b + a1)*C2;
dC3 = a1*C2 + b2*O - (b1 + a2)*C3;
dO = a2*C3 + ai*I + Drug_Model_pars.koff*DO - (b2 + bi + Dkon)*O;
dI = bi*O + Drug_Model_pars.koff*DI - (ai + Dkon)*I;

if (Dkon == 0) % only calculate these rates if Drug present
    dDC1 = 0;
    dDC2 = 0;
    dDC3 = 0;
    dDO = 0;
    dDI = 0;
else
    dDC1 = Db*DC2 - Da*DC1;
    dDC2 = Da*DC1 + Db1*DC3 - (Db + Da1)*DC2;
    dDC3 = Da1*DC2 + Db2*DO - (Db1 + Da2)*DC3;
    dDO = Da2*DC3 + ai*DI + Dkon*O - (Db2 + bi + Drug_Model_pars.koff)*DO;
    dDI = bi*DO + Dkon*I - (ai + Drug_Model_pars.koff)*DI;
end

dX = [dC2; dC3; dO; dI; dDC1; dDC2; dDC3; dDO; dDI];