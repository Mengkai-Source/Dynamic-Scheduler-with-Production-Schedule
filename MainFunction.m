%%%%%----- Simulated Annealing for discrete optimization (DMDII)----%%%%%

function MainFunction
%
%  This is the main function to run the Dynamic Scheduler and display the preliminary results.
%
%  Inputs:
%        Load data: load the future predicted degradation path which is
%        provided by PDX.
%
%  Outputs:
%        The optimized thresholds for spare part order placement and
%        thresholds for performing maintenance are displayed. Those two
%        thresholds are translated into the countdown time for order
%        placement and maintenance performance and displayed as well.
%        Two values of order placement threshold (Xo) and 
%        maintenance performance threshold (Xm) and displays the 
%        corresponding countdown time To (Order placement) and Tm (Maintenance performance).
%
%
%  Format of outputs:
%        Current format displays two values of order placement threshold
%        and maintenance performance threshold and displays the corresponding 
%        countdown time. In addition, actionable signal indication which can 
%        be refered to suggest the actions with 
%        respect to order purchase and maintenance performance.
%        
%  NU_Version1.0
%  by Anqi He, Northeastern University, Boston

close all
clear all
clc
%tic
% Global 
global X L Xf C1 C2 C3 Cws Cwc N M C0 delta_t xlower xupper xdelt;

% Import the data of the future predicted degradation path
load('Sample_Data 06.04.mat'); %Import the sample data from PDX

X=HI_Curves';
%% Define the feasible region

Xf = 1;  % Provided by PDX
L = 3;  % Lead time(settle down regarding the real case )
xdelt= 0.005; %0.005

% Pre-check the validity of the predicted paths
% Here, we need to gaurantee the lower bound value of provided degradation
% paths all above the failure threshold

%%%%%%%% create two datasets for validation %%%%%%%%%%%%%%%%
% disp('Value within specified range.')
% Remove the columns in which the last obsevation is less than the value of failure threshold
if length(find(X(end,:)<Xf))/size(X,2)==0
    X = X;
elseif length(find(X(end,:)<Xf))/size(X,2) < 0.8
    X(:,find(X(end,:)<Xf))=[];
else
    disp(' Warning: data is insufficient, please input new predicted degradation data!');
end 
[row,col] = size(X);
N = row; % The time length of predicted degradation paths( provided by PDX )
M = col; % Number of predicted paths

% Plot the data of predicted paths
figure(1)
for i= 1:M
   plot(X(:,i));hold on;
end

% Initial Parameters Setting

C1 = 15; % Maintenance cost for type 1
C2 = 20; % Maintenance cost for type 2
C3 = 40; % Maintenance cost for type 3
Cws = 1; % Cost of waiting time of suppliers per unit time  %%% original 1
Cwc = 1000; % Cost of waiting time of suppliers per unit time 10 %%% original 1000
C0 = 0.5; % Initial cost can be removed
delta_t = 1 ; % Unit time (provided by PDX)

%% SA for Optimization
% Create vectors containing the lower bound (|lb|) and upper bound constraints(|ub|).
% Transform the bounds into discrete variables.
xlower = min(min(X)); %%% X(1,1)min(min(X))
xupper = Xf;
l = [1 1];   
u = [length(xlower:xdelt:xupper) length(xlower:xdelt:xupper)];
ini=ceil((u-l).*abs(rand(1,2)));%Initial guess for the minimum (threshold to order, threhold to perform maintenance)
% Call the SA function to solve the problem with discrete variables.
C=@CostRate;
[x0,f0]=sim_anl(C,ini,l,u,400);
%toc
% _Analyze the Results_
xbestDisc = MapVariables(x0); 
%display(xbestDisc)  % Display the optimimal order placement threshold and maintenance threshold
Xo=xbestDisc(1); %0.9576
Xm=xbestDisc(2); %0.7826
%fprintf('\nCost rate return by SA = %g\n',f0); %Display the optimal value of the objective function
%fprintf('\n Threshold for order placement Xo = %g\n',Xo)
%fprintf('\n Threshold for maintenance Xm = %g\n',Xm)
%% Calculate the risk
% Import the production schedule information
% Extract the position of the ending time of each time points
%%%%%%%%%%%%% Mengkai 
[num,text,both]= xlsread('Orders_Scheduled_06.04.xlsx');

Pro_Schedule = text(2:end,4:5); % Extract the production schedule
[r c] = size(Pro_Schedule);

% Calculate the time duration for each order
for i =1:r
T1 = datetime(Pro_Schedule{i,1});
T2 = datetime(Pro_Schedule{i,2});
P(i) = T2 - T1;
end
P.Format='d';  % Format the time duration in days
P=days(P); P=round(P); % Convert duration array to numeric array by rounding the numerical value to the nearest integer

p=cumsum(P); % The derived end ponits for each order
%%%%%%%%%%
%p = [8, 15, 30];
Risk = RiskFunc(X, p); % Calculate risk for each order
%% Dispaly risk corrsponding to each order
order_risk=Risk.batch;
order_risk=vpa(order_risk);
order_ind =1:r;
order_risk=[order_ind;order_risk];
fprintf('Risk for each order: ');
fprintf('%g ', order_risk);
fprintf('\n');

%% Dispaly risk for each upcoming day
Day_R=2:row;
Day_Risk = RiskFunc(X, Day_R);% Calculate risk for each order
Daily_risk=Day_Risk.batch;
Daily_risk=vpa(Daily_risk);
fprintf('Risk for the current time and time in the future: ');
disp(Daily_risk);
%% Dispaly the countdown time
Xo=xbestDisc(1); %0.9576
Xm=xbestDisc(2); %0.7826
%Calculate To
TO=0;
for i=1:col
r=min(find(X(:,i)>Xo));
TO=r+TO;
end
To=TO/col-1; % Countdown time from today 1 to the order palcement date To;
To = round(To);
% countdown time array from the beginning time of prediction to order time
To_array=linspace(To,0,To+1);

%Calculate Tm
TM=0;
for i=1:col
    rr=max(find(X(:,i)<Xm));
    TM=rr+TM;
end
Tm=TM/col-1; % Countdown time from today 1 to the maintenance date Tm;
Tm = round(Tm);
% countdown time array from the beginning time of prediction to maintenance time
Tm_array=linspace(Tm,0,Tm+1);

% Countdown time display 
fprintf('\n Countdown time to place order To = %g\n',To_array(5))
fprintf('\n Countdown time to perform maintenance Tm = %g\n',Tm_array(5))
