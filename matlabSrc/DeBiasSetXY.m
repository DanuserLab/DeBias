
function [xout,yout] = DeBiasSetXY(x,y,isCoOrientation)
%% Sanity test, adjusting angles from radian to degrees, normalize
% Input: x,y - arrays of matching variables from different sources (e.g., velocity vs. stress, MT vs. VIM)
%        isCoOrientation - co-orientation (true), co-localization (false)
% Output: xout,yout, sanity check + normalization
%
% Assaf Zaritsky, January 2017
%%

assert(length(x) == length(y));

if isCoOrientation
    xout = DeBiasSetOrientationData(x);
    yout = DeBiasSetOrientationData(y);
else
    [xout,yout] = DeBiasSetCoLocalizationData(x,y);
end
end