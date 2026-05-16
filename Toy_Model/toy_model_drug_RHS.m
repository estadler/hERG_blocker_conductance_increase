%Steffen Docken
%5-20-18
%Code for the Right Hand Side of the system of differential equations for
%the reduced hERG model in Adeniran et al. 2011. In the original paper, the
% model was fit to data at physiological temperater (37C), so that is what
% the baseline parameters here represent.

function dX = toy_model_drug_RHS(~ ,X , V, Drug_Model_pars)

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

%dC = beta*O - alpha*C; %Not needed, because 
% C is calculated as 1-sum of all
%other states by conservation of proportion
dO = alpha*C + koff*O_star - (beta + Dkon)*O;
if (Dkon == 0)
    dO_star = 0;
    dC_star = 0;
else
    dO_star = alpha_star*C_star + Dkon*O - (beta_star + koff)*O_star;
    dC_star = beta_star*O_star - alpha_star*C_star; 
end

dX = [dO; dO_star; dC_star];