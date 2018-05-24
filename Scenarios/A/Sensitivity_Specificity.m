function [Sensitivity,Specificity] = Sensitivity_Specificity(results)
%SPECIFI Summary of this function goes here
%   Detailed explanation goes here
%   Example : Class TSOthers and TSStop (Class 1 , Class 2)
%   True Positives -> Detected TS Stop and it's TSStop
%   True Negative  -> Detected its TS Other and it's TSOthers
%   False Positive -> Detected TS Stop and it's TSOthers
%   False Negative -> Detected TS Other and its TSStop
    TP = length(find(results.Results < 0 & results.Class == 2));
    TN = length(find(results.Results > 0 & results.Class == 1));
    FP = length(find(results.Results < 0 & results.Class == 1));
    FN = length(find(results.Results > 0 & results.Class == 2));
%     disp(TP);
%     disp(FN);
%     disp(FP);
%     disp(TN);
    
    
    Sensitivity = TP / (TP + FN);
    Specificity = TN / (TN + FP);
end

