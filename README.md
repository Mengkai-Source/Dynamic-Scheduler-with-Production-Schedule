# Dynamic-Scheduler-SA
This version with the updated optimization algorithm SA

Dynamic-Scheduling-SA
Prof.Xiaoning Jin, Prof.Kamarthi, PhD student: Anqi He, Mengkai Xu

This is a preliminary demo of the dynamic scheduler for test implementation. There are six files in the folder. One sample data file : 'path.mat', and five Matlab functions: 'MainFunction.m', 'CostRate.m', 'sim_anl.m', 'mu_inv.m', 'MapVariables'. Per the discussion with PDX and FORCAM, Current format displays two values of order placement threshold (Xo) and maintenance performance threshold (Xm) and displays the corresponding countdown time To (Order placement) and Tm (Maintenance performance).  In addition, actionable signal indication which can be refered to suggest the actions with respect to order purchase and maintenance performance will be on the dashboard as well after discussion with PDX.

#1. Data file: Input Dataset (path.mat)

Input Dataset is N X M matrix which consists of multiple degradation paths of predicted machine health values from PDX

N: Time index
M: Path index

The machine health values of the first row should be same because all paths start at the same prediction trigger time

#2. Runing environment: MATLAB (No version requirement & No Toolbox is needed)

#3. Function file: Install

'MainFunction.m':This is the main function to run the Dynamic Scheduler and display the preliminary results. The Outputs from running this function contain two values of order placement threshold (Xo) and maintenance performance threshold (Xm) and displays the corresponding countdown time To (Order placement) and Tm (Maintenance performance).

'CostRate.m': This function is the objective function to calculate the 'cost' metric based on the predicted degradation path.

'MapVariables.m': MapVariables interatively assign values to the elements in vector x

'sim_anl.m': Minimizes a function with the method of simulated annealing

'mu_inv.m': This function is used to generate new point according to lower and upper and a random factor proportional to current point.

#4. Run

Run the main program: "MainFunction"
