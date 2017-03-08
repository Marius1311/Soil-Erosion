function dX = EQN(t,  y, delta, lambda, hc )
dX = zeros(2, 1);
h = y(1);
c = y(2);
dX = [1/lambda*h^3/(h^3 - hc^3)*(lambda*delta - lambda*delta*h^(-10/3) + h^(-13/3) - c) ; ...
    h^(-13/3) - c];
end


