%Steffen Docken
%5-20-18
%Code for the Right Hand Side of the system of differential equations for
%the reduced hERG model in Adeniran et al. 2011

function Flux_vec = Adeniran_r_drug_flux(~ ,X , V, Ko, Drug_Model_pars, Temp)

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

%fluxes
C1toC2 = a*C1 - b*C2;
C2toC3 = a1*C2 - b1*C3;
C3toO = a2*C3 - b2*O;
ItoO = ai*I - bi*O;

if (Dkon == 0) % these fluxes are only non-zero if Drug is present
    DOtoO = 0;
    DItoI = 0;
    
    DC1toDC2 = 0;
    DC2toDC3 = 0;
    DC3toDO = 0;
    DItoDO = 0;
else
    DOtoO = Drug_Model_pars.koff*DO - Dkon*O;
    DItoI = Drug_Model_pars.koff*DI - Dkon*I;
    
    DC1toDC2 = Da*DC1 - Db*DC2;
    DC2toDC3 = Da1*DC2 - Db1*DC3;
    DC3toDO = Da2*DC3 - Db2*DO;
    DItoDO = ai*DI - bi*DO;
end

Flux_vec = [C1toC2, C2toC3, C3toO, ItoO, DOtoO, DItoI, DC1toDC2, ...
    DC2toDC3, DC3toDO, DItoDO];