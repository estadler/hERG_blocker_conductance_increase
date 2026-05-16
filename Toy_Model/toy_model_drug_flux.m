%Steffen Docken
%6-26-25
%Code for fluxes between states in the toy model

function Flux_vec = toy_model_drug_flux(~ ,X , V, Drug_Model_pars)

Dkon = Drug_Model_pars(1); %[D]k_on
koff = Drug_Model_pars(2); %k_off
z = Drug_Model_pars(3);
p1 = Drug_Model_pars(4);
p2 = Drug_Model_pars(5);
k = Drug_Model_pars(6);

C = 1 - sum(X);
O = X(1);
O_star = X(2);
C_star = X(3);

alpha = z*exp((V-p1)/p2);
beta = z*exp((V-p1)/(-p2));

alpha_star = k*alpha;
beta_star = beta;

OtoC = beta*O - alpha*C;

if (Dkon == 0)
    O_startoO = 0;
    C_startoO_star = 0;
else
    O_startoO =  koff*O_star - Dkon*O;
    C_startoO_star = alpha_star*C_star - beta_star*O_star;
end

Flux_vec = [OtoC, O_startoO, C_startoO_star];