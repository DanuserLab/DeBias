
function [xout] = DeBiasSetOrientationData(x)
%% Sanity test, adjusting angles from radian to degrees
% Assaf Zaritsky, January 2017
%%
% x is assumed to be an orientation (not a vector) in the range [-90,90]
if  (max(x) > 180) || (min(x) < -180)
    display('MATLAB ERR: erroneous x data - x must be in the [-180,180] (or [-pi,pi]) range')
    error('erroneous x data - x must be in the [-180,180] (or [-pi,pi]) range')
end

% Set data in the range [90,180], [-90,-180] to [-90,90]
if  (max(x) > 90) || (min(x) < -90)
    x(x<-90) = 180 + x(x<-90);
    x(x>90) = x(x>90) -180;
    assert((max(x) < 90) || (min(x) > -90));
end

if (max(x) < 1 && min(x) > -1)
    display('MATLAB WARNING: Are you sure that variable x is your data? All input < 1');
    warning('Are you sure that variable x is your data? All input < 1');
end

xout = x;

% If x,y in radians translate to degrees
if max(x) <= pi/2
    xout = rad2deg(xout);   
end
end