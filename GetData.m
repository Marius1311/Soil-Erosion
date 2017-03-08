function [ t1, y1, t2, y2, hAna, cAna ] = GetData( lambda, delta, hc, tMax, tMin, Eps )
%This function returns the values for c and h, given a certain value of
%lambda

%% Expansion

% Compute the initial value for c
cc = lambda * delta * (1 - hc^(-10/3)) + hc^(-13/3);

% Derivative of the concentration at the critical point
cPrime = hc^(-13/3) - cc;

% Expansion coefficients
b0 = 1/2* ( (10/9*lambda*delta*hc-13/9) - sqrt( (10/9*lambda*delta*hc - 13/9)^2 - 4/3*lambda*hc^(26/3)*cPrime ) );
a0 = -lambda*hc/b0*cPrime;

% Second derivative of the concentration at the critical point
cDPrime = -13*b0/(3*lambda*hc^(29/3)) - cPrime;

% Further expansion coefficients
a1 = ( (2*hc^(13/3)*a0-5/27*lambda*delta*hc+26/27)*lambda*hc^(16/3)*cPrime/(2*b0^2) - lambda^2*hc^(32/3)*cDPrime/(2*b0^2))...
    /(1 - hc^(29/3)*lambda/(6*b0^2)*cPrime);
b1 = hc^(13/3)/3*(a1+2*a0) - 5/27*lambda*delta*hc + 26/27;

% Analycic expression for h(t) around the critical point
hAna = @(t) hc*(1 + b0*t/(lambda*hc^(16/3)) + b0*b1*t.^2/(2*lambda^2*hc^(32/3)));

% Analytic (just taylor) expansion of c around the singularity:

cAna = @(t) cc + t*cPrime + t.^2/2*cDPrime;

% Analytic expression for t(h) around the critical point
% tAna = @(h) lambda*hc^(16/3)/b0*(h/hc - 1) - b1*lambda*hc^(16/3)*(h/hc-1).^2/(2*b0^2);

%% Integration

% Define an anonymus function for the solver
fun = @(t, y) EQN(t, y, delta, lambda, hc );

% Another dummy function
fun2 = @(t, y) myEventsFcn(t,y, hc);

% We will need to call an events functions and we need to set bounds on the
% step size
options = odeset('Events', fun2, 'MaxStep', 1e-2);

% Run the integration to the right
[t2,y2] = ode45(fun, [Eps,  tMax], [hAna(Eps), cAna(Eps)], options);

% We need to don the same thing for the other direction (left)
[t1, y1]  = ode45(fun, [-Eps,  tMin], [hAna(-Eps), cAna(-Eps)], options);

end


