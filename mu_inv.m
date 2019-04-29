function x=mu_inv(y,mu)
%This function is used to generate new point according to lower and upper
%and a random factor proportional to current point.
x=(((1+mu).^abs(y)-1)/mu);
%x=(((1+mu).^abs(y)-1)/mu).*sign(y);
end