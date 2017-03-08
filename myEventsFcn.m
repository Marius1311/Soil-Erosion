function [value,isterminal,direction] = myEventsFcn(t,y, hc)
%This records the some values at discrete steps

value(1)  =  y(1) -0.1;
value(2) = y(2) - 0.1;
value(3) = y(1) - hc;
isterminal(1) = 1;
isterminal(2) = 1;
isterminal(3) = 1;
direction(1) = 0;
direction(2) = 0;
direction(3) = 0;


% l = length(xiRightRange);
% value  =  xiRightRange' - t*ones(l, 1);
% isterminal = zeros(l, 1);
% direction = zeros(l, 1);

% We also have to prevent h from becomign negative

end

