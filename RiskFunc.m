%% Failure Risk funtion 
%  NEU
%  We will achieve the following functions:
%     1. Input the prodoction schedule information 
%     2. Transfer the date to number of days-- match with the predicted
%     degradation paths
%     3. Calculate the failure risk 
%         3.1 Calculate the failure risk of the ending time of each batch(comparing with the thresholds)
%         3.2 Calculate the failure risk of each time point(set the interval as a variable)
%     5. Mark the current time on the time line of production schedule 
%  x is predicted degradation path
%  p is production schedule information 
%  output: Risk and coresponding time  
% Global variable: Xf, M, N
%  x: MxN global variables  
%  Input p : positions for the ending time of each batch
function Risk = RiskFunc(x, p)
global Xf M N 
%% Calculate the failure risk of each datapoint
R_all = [];
for i = 1 : N
    n = 0;
    for j = 1:M
        if x(i,j)>= Xf
            n = n+1;
        else
            n = n;
        end
    end
    R_all = [R_all,n/M];
end
%% Calculate the failure risk of the ending time of production batch
% the position of the ending time
T = length(p);
R_batch = zeros(1,T); % T: number of batch
for i = 1: T
    R_batch(i) = R_all(p(i)); 
end
Risk = [];
Risk.all = R_all;
Risk.batch = R_batch;
end





