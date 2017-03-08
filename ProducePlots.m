function [] = ProducePlots( FinalResult, delta, hc, Eps, Fr, S0)
%Given a value of lambda, this produces plots for both h and c

% Generate the data:
lambda = FinalResult(1, 1);
cc = lambda * delta * (1 - hc^(-10/3)) + hc^(-13/3);
tMax = FinalResult(1, 2);
tMin = FinalResult(1, 3);
[ t1, y1, t2, y2, hAna, cAna ] = GetData( lambda, delta, hc, tMax, tMin, Eps );

% Generate data points for the expansion:
tR = linspace(-Eps, Eps);
hA = hAna(tR);
cA = cAna(tR);
LW = 'LineWidth';

% Deterine good plotting ranges
yMinh = min([y1(:, 1); y2(:, 1)]) - 0.02;
yMaxh = max([y1(:, 1); y2(:, 1)]) + 0.02;
yMinc = min([y1(:, 2); y2(:, 2)]) - 0.02;
yMaxc = max([y1(:, 2); y2(:, 2)]) + 0.02;

figure;

% Plot h(t)
subplot(2, 1, 1), plot(flip(t1), flip(y1(:, 1)), LW, 1.3),hold on, plot(tR, hA, LW, 1.3), ...
    plot(t2, y2(:, 1), LW, 1.3),  title(['h(t), \lambda = ', num2str(round(lambda, 3)), ', \delta = ', num2str(round(delta, 3)), ', S0 = ', num2str(round(S0, 5)), ', Fr = ', num2str(Fr) ]),...
    grid, xlabel('t'), ylabel('h'),ylim([yMinh, yMaxh]), xlim([tMin, tMax]), ...
    plot([tMin, tMax], [y2(end, 1), y2(end, 1)], '--'), legend({'LeftNum', 'Analytical', 'RightNum'}), ...
    plot(0, hc, 'o', LW, 1.3);

% Plot c(t)
subplot(2, 1, 2), plot(flip(t1), flip(y1(:, 2)), LW, 1.3),hold on, plot(tR, cA, LW, 1.3),...
    plot(t2, y2(:, 2), LW, 1.3),  title('c(t)'), grid, xlabel('t'), ylabel('c'), ylim([yMinc, yMaxc]), xlim([tMin, tMax]), ...
    plot([tMin, tMax], [y2(end, 2), y2(end, 2)], '--'), legend({'LeftNum', 'Analytical', 'RightNum'}), ...
    plot(0, cc, 'o', LW, 1.3);

end

