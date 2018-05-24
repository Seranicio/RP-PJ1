% This will pass Struct Dataset to a array dataset where X is features and
% y is classID.

function features = OrganizeStruct(HOG,numfeatures,numfiles)
%ORGANIZESTRUCT Summary of this function goes here
%   Detailed explanation goes here
    features.X = zeros(numfeatures,numfiles);

    % HOG : Run and get a sip of coffee it's gonna take a while.
    % Preparing Structure for Kruskal-Wallis analysis.
    for i=1:numfeatures
        aux = cellfun(@(x) x(i) ,HOG(:,:)); %Getting first element of every file.
        % Converting to all data to rows and assigning to feature array.   
        aux = aux';
        aux = aux(:)';
        features.X(i,:) = aux;
        if(i == 750)
            disp('PC: It hurts...');
        end
    end
    clear aux;
    
    
    disp('PC: Finally...');
    % getting stop traffic sign position to for structure classify.
    aux = 0;
    for k=1:numfiles / 210
        features.y(aux+1:aux+210) = k-1;
        aux = aux + 210;
    end
end

