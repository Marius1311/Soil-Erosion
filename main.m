%% Single Concentration

%% Initialise

% % Set some physical constants
% Fr = 1.31;
% hc = Fr^(2/3);
% n = 0.02;
% h0 = 0.0895;
% q0 = 0.1097;
% v0 = 0.4;
% u0 = q0/h0;
% delta = n^2 *u0^3 /(v0*h0^(4/3));

% Constants
q0 = 0.1097;
n = 0.02;
g = 9.81;
v0 = 0.4;

% Free parameter: Bed slope
S0 = 0.015;

% Calculate
h0 = (n^2*q0^2/S0)^(3/10);
u0 = q0/h0;
Fr = sqrt(q0^2/(g*h0^3))
pause
hc = Fr^(2/3);
delta = n^2 *u0^3 /(v0*h0^(4/3));

% lamba resolution 
n = 10;

% Choose a range for lambda
lambdaRange = linspace(5, 8, n); % Range of values we will try

% Create a Matrix to store the results
resultsMat = zeros(n, 6);

% Set minimum and maximum times
tMax = 14;
tMin = -4;

% Set a minimum number of timestpes required to the right
sMinRight = 100;

% We have to start a little bit away from the singuarity (in time)
 Eps = 0.05;

%% Loop

% We Loop over the positive wavespeed
k = 1;

% We will measure how long this takes us
tic;

for lambda = lambdaRange

% Produce time series data to the left and right of singularity
[ t1, y1, t2, y2, hAna, cAna ] = GetData( lambda, delta, hc, tMax, tMin, Eps );

% Check the contidions
if length(t2) > sMinRight
    Result = GetCandidates( t1, y1, t2, y2, Fr, sMinRight, cAna, Eps, hc );
    if isempty(Result)
       continue
    end
else
    continue
end

% Save the value of lambda and the best match that was found for this value
resultsMat(k, :) = [lambda, Result];

% update the loop counter
k = k+1;
end

time = toc;

%% Give out a Final Result

if isempty(resultsMat)
    disp('No results found.');
else
    resultsMat = resultsMat(1:(k-1), :);
    if isempty(resultsMat)
        disp('No results found.');
    else
        [minError, FinalIndex] = min(resultsMat(:, 5));
        FinalResult = resultsMat(FinalIndex, :);
        rTable = array2table(resultsMat, 'VariableNames', {'lambda', 'tRight', 'tLeft', 'cDiff', 'QDiff', 'L2Error'});
        disp(rTable);
        fprintf('Best value of lambda found: %1.3f, with an L2 error of %1.5f and a time span from %1.2f to %1.2f. \n Computation time needed: %1.1f s. \n',...
        FinalResult(1,[1,6,3,2]), time);
    end
end

%% Plot the result found

if ~isempty(resultsMat)
    ProducePlots( FinalResult, delta, hc, Eps, Fr, S0);
end

