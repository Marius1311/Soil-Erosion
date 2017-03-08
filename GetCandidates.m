function [ Result ] = GetCandidates( t1, y1, t2, y2, Fr, sMinRight, cAna, Eps, hc )
%This function returns a vector of ranges that fulfill all three conditions
% Those conditions are: 1.) The hydraulic boundary conditios, 2.) The
% continuity condition for the concentration and 3.) The mass conservation
% equation for the concentration

%Create a Matirx to store the results. Columns represent:
% 1.) Index on the right, 2.) Index on the left, 3.) Concentration Cond.
% 4.) Intagral Cond, 5.) L2 norm of the last two
IndexMatrix = zeros(length(t2) - sMinRight, 5);

% this function is the solution of the hydraulic jump condition to find
% hLeft
hF = @(a, b) 2*a/(3^(1/3)*(sqrt(3)*sqrt(27*b^2-8*a^3)-9*b)^(1/3)) ... 
    + (sqrt(3)*sqrt(27*b^2 - 8*a^3)-9*b)^(1/3)/3^(2/3);

% Integral over the central expansion
QMiddle = integral(cAna,-Eps, Eps );

% Integral over the part that we always intergate over
QConstant = trapz(t2(1:(sMinRight-1)), y2(1:(sMinRight-1), 2));
QRight = QConstant;
QLeft = 0;

indexOld = 1;

% We will simply loop over the points the the right of the singularity
l = 1;
for i = sMinRight:length(t2)
    
   % Get the value of h at the right
   hRight = y2(i, 1);
   
   % Get the time at that point
   tRight = t2(i);
   
   % Get the value of the hydraulic term
   HydroRight = Fr^2/hRight + hRight^2*0.5;
   
   % Integral over the right part, using the former integrations
    QRight = QRight + trapz(t2(i-1:i), y2(i-1:i, 2)); 

    % Computes the corresponding h on the left
    hLeft = real(hF(HydroRight, Fr^2));
    if hLeft < hc || hLeft > 3
        continue
    end
   
   % Let's find the h on the left that comes closest to this theoretical h
   [val, indexNew] = min(abs(hLeft - y1(:, 1)));
   if val > 0.1 || indexNew < 10
       continue
   end
   
   % Let's take the corresponding t (on the left -> negative)
   tLeft = t1(indexNew);
   
  % We will now check the concentration condition and this point and record
  % the error:
   cDiff = abs(y1(indexNew, 2) - y2(i, 2));
   
   % Check whether that loooks okay at all
   if cDiff > 0.1
       continue
   end
   
   % Last condition: Check the value of the integral Q versus the length L
   % and record the error
   
   % QRight = trapz(t2(sMinRight-1:i), y2(sMinRight-1:i, 2)); % Integral over the right part
   
   if indexNew > indexOld
        QLeft = QLeft + trapz(t1(indexNew:-1:indexOld), y1(indexNew:-1:indexOld, 2));
   elseif indexNew < indexOld
        QLeft = QLeft + trapz(t1(indexNew:indexOld), y1(indexNew:indexOld, 2));
   end
   
   Q = QRight + QLeft + QMiddle;
   L = tRight - tLeft;
   QDiff = abs(L - Q);
   
   indexOld = indexNew;
   
   % Fill the matrix
   IndexMatrix(l, :) = [tRight, tLeft, cDiff, QDiff, norm([cDiff, QDiff], 2)];
   l = l+1;
end

IndexMatrix = IndexMatrix(1:(l-1), :);
[m, findex] = min(IndexMatrix(:, 5));
Result = IndexMatrix(findex, :);

end


