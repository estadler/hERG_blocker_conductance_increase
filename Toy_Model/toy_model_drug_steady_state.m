%Steffen Docken
%6-15-25
%Code to solve for the steady state channel occupancies of the toy model

function X_steady_state = toy_model_drug_steady_state(V, Drug_Model_pars)

Dkon = Drug_Model_pars(1); %[D]k_on
koff = Drug_Model_pars(2); %k_off
z = Drug_Model_pars(3);
p1 = Drug_Model_pars(4);
p2 = Drug_Model_pars(5);
k = Drug_Model_pars(6);

alpha = z*exp((V-p1)/p2);
beta = z*exp((V-p1)/(-p2));

alpha_star = k*alpha;
beta_star = beta;

if (Dkon == 0) %i.e., no drug
    O = alpha/(alpha + beta);
    O_star = 0;
    C_star = 0;
else
    O = alpha/(alpha*beta_star*Dkon/(alpha_star*koff) - ...
        (koff - alpha)*Dkon/koff + ...
        (beta + Dkon + alpha));
    C_star = Dkon*beta_star/(alpha_star*koff)*O;
    O_star = alpha_star/beta_star*C_star;
end

X_steady_state = [O, O_star, C_star];