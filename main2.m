%% Single Concentration

%% Initialise

Fr = 1.31;
hc = Fr^(2/3);
n = 0.02;
h0 = 0.0895;
q0 = 0.1097;
v0 = 0.4;
u0 = q0/h0;
delta = n^2 *u0^3 /(v0*h0^(4/3));

% For the iteration and the integration
n = 100; % lamba resolution 
epsilon = 0.01;
lambdaRange = linspace(0.01, 16, n); % Range of values we will try
xiRightRange= linspace(epsilon, 13); % Grid for xi to the right
resultsMat = zeros(n, 2);
tMax = 15;
tMin = -4;


%% Loop

% We Loop over the positive wavespeed
k = 1;
for lambda = lambdaRange

% Save the value of lambda
resultsMat(k, 1) = lambda;
    
% Compute the initial value for c
cc = lambda * delta * (1 - hc^(-10/3) + hc^(-13/3));

% Define an anonymus function for the solver
fun = @(t, y) EQN(t, y, delta, lambda, hc );

% Another dummy function
fun2 = @(t, y) myEventsFcn(t,y, xiRightRange);

% We will need to call an events functions and we need to set bounds on the
% step size
options = odeset('Events', fun2, 'MaxStep', 0.1);

% Run the integration to the right
[t2,y2] = ode45(fun, [0,  tMax], [hc - 0.05, cc], options);

% We need to don the same thing for the other direction (left)
[t1, y1]  = ode45(fun, [0,  tMin], [hc + 0.05, cc], options);

%% Check the contidions
if length(t2) >= 100
myarray = zeros(length(t2(100:end)), 2);
    

nCandidates = 0;
for i = 100:length(t2)
   hRight = y2(i, 1);
   tRight = t2(i);
   Right = Fr^2/hRight + hRight^2*0.5;
   LeftRange = abs(Fr^2./y1(:, 1) + 0.5*y1(:, 1).^2 - Right);
   candidates = LeftRange < 0.035;
   sequence = (1:length(y1))';
   indices = sequence(candidates);
   concentrations = abs(y1(candidates, 2) - y2(candidates, 2));
   CCandidates = concentrations < 0.005;
   nCandidates = nCandidates + sum(CCandidates);  
   % myarray(i, 1) = tRight;
   % myarray(i, 2) = sum(candidates);
end

end

resultsMat(k, 2) = nCandidates;
% update the loop counter
k = k+1;
end


%% Plot
figure(2);
plot(t1, y1, 'LineWidth', 1);
legend(['h'; 'c']);

%% Rest
















 h = figure('KeyPressFcn','keep=0');
% Choose lambda
lambda = -0.043;
dlambda = 0.01;
keep = 1;

 while keep

% Compute the initial value for c
 cc = lambda * delta * (1 - hc^(-10/3) + hc^(-13/3));


% Define an anonymus function for the solver
fun = @(t, y) EQN(t, y, delta, lambda, hc );

% run the integration
[T1, Y1] = ode45(fun, [0,  15], [hc - 0.1, cc]);

%figure('pos',[10 300 400 300]);

%h;%
 plot(T1, Y1(:, 1)), xlabel('t'), ylabel('h'), title({'Height, \lambda = ', num2str(lambda)});

 % figure('pos',[600 300 400 300]);
  h;
 plot(T1, Y1(:, 2)), xlabel('t'), ylabel('c'), title('Concentration'),title({'Concentration, \lambda = ', num2str(lambda)});

  pause(0.1);
 lambda = lambda + dlambda;

 end



