function [ FinalResult ] = GetLambda( lambdaRange, delta, Fr, hc, tMax, tMin, Eps, sMinRight, n )
%This function finds the speed of the shock lambda, given delta, the froude
%number and a bunch of other constants

%% Loop

% Create a Matrix to store the results
resultsMat = zeros(n, 6);

% We Loop over the positive wavespeed
k = 1;

for lambda = lambdaRange

% Produce time series data to the left and right of singularity
[ t1, y1, t2, y2, hAna, cAna ] = GetData( lambda, delta, hc, tMax, tMin, Eps );

% Check the contidions
if length(t2) > sMinRight
    Result = GetCandidates3( t1, y1, t2, y2, Fr, sMinRight, cAna, Eps, hc );
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

%% Give out a Final Result

if isempty(resultsMat)
    FinalResult = [lambda, 0,0,0,0,0,0];
else
    resultsMat = resultsMat(1:(k-1), :);
    [minError, FinalIndex] = min(resultsMat(:, 5));
    FinalResult = resultsMat(FinalIndex, :);
end

end


