%% Soil Modelling, response to changes in slope and Fraude Number

%% Initialise

% lamba resolution 
n = 10;

% Choose ranges for lambda, delta and the froude number
lambdaRange = linspace(2, 20, n); % Range of values we will try
deltaRange = linspace(0.01, 0.1, 3);
% FrRange = linspace(1.25, 1.4, 3);
FrRange = 1.31;

% Set minimum and maximum times
tMax = 14;
tMin = -4;

% Set a minimum number of timestpes required to the right
sMinRight = 1000;

% We have to start a little bit away from the singuarity (in time)
 Eps = 0.05;

 
 
 %% Loop over lambda and Fr
f = 1;
 
 for Fr = FrRange
     for delta = deltaRange
          hc = Fr^(2/3);
          GetLambda( lambdaRange, delta, Fr, hc, tMax, tMin, Eps, sMinRight, n );
          figure(f);
          plotSoil(FinalResult, delta, hc, Eps, Fr, f);
          f =f+1;
     end
 end
 

 