function [PCA_data,model,SelectedFeatures] = ScenaryA(features,ClassID)
%	ATTENTION THIS SCRIPT IS DIFFERENT FROM SCENARY A , some things were
%   change in other to get better results from binary tree classifier.

    numfeatures = size(features.X,1);
    numfiles = size(features.X,2);

    if(length(ClassID) == 1)
        features.y(features.y ~= ClassID) = 1;
        features.y(features.y == ClassID) = 2;
    else
        for a=1:length(ClassID)
            features.y(features.y == ClassID(a)) = 2;
        end
        features.y(features.y ~= 2) = 1;
    end
    
    disp('Processing Kruskal-Wallis...');
    % Kruskal - Wallis
    rank = cell(numfeatures,2);
    for i=1:numfeatures
        [p,atab,stats] = kruskalwallis(features.X(i,:)',features.y,'off');
        rank{i,1} = "Feature " + int2str(i);
        rank{i,2} = atab{2,5};
    end
    
    disp('Processing values for PCA');
    maxValues = sort([rank{:,2}] , 'descend');
    percentage = max(maxValues)*0.8; %Removing Redudand data 80% of max value (Note: This is alot. I used this high
    % to represent clusters in PCA with dimension 3. normaly we can do about more and less 10% of
    % the max value removed and then calculate the number of pca dimensions we 
    % want with the Kaiser Criterion or Scree Test, but this way we cannot see
    % clusters./
    maxPositions = find( [rank{:,2}] > percentage);
    SelectedFeatures = maxPositions;
    
    disp('Redudand data removed');

    for i=1 : length(maxPositions)
        kruskal_data.X(i,:) = features.X(maxPositions(i),:);
    end
    
    kruskal_data.y = features.y;
    kruskal_data.dim = numfeatures;
    kruskal_data.num_data = numfiles;
    
    % PCA
    global Analysis;
    if(Analysis == 1)
        % PCA
        disp('Processing PCA');
        model = pca(kruskal_data.X,3);
    else
        % PCA
        disp('Processing LDA');
        model = lda(kruskal_data,3);
    end
    PCA_data = linproj(kruskal_data,model);

    % ppatterns see clusters.
%     figure;
%     title('Clusters');
%     ppatterns(PCA_data);  
end

