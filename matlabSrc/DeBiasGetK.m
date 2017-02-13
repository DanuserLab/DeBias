%% DeBiasGetK: estimate K using the Freedman Diaconis rule 
% K = 90 / binWidth for angular data and 2.0/binWidth otherwise
% Input: data - is the alignment data after normalization!
%        isCoOrientation - true (co-orientation), false (co-localization).
% Output: calculated K
%
% Assaf Zaritsky, January 2017
function K = DeBiasGetK(data,isCoOrientation)

binWidth = FreedmanDiaconis(data);

if isCoOrientation
    K = 90 / binWidth;
else
    K = 2.0 / binWidth;
end

end