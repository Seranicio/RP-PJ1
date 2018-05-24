function [PCA_data,PCA_model,SelectedFeatures] = ScenaryA(HOG,ClassID)
%SCENARYA Summary of this function goes here
%   Detailed explanation goes here
    disp(strcat('Analizing...',HOG));
    disp('Loading data...');
    HOG = load('HOG_DATA.mat',HOG);
    HOG = struct2cell(HOG);
    HOG = HOG{1};

    numfeatures = length(HOG{1,1});
    numfiles = size(HOG,1) * size(HOG,2);

    disp('Organizing data... This takes a while...');
    disp('PC: *Sips coffee* ');
    disp('PC: Lets do This...');
    
    features = OrganizeStruct(HOG,numfeatures,numfiles);
    features.y(features.y ~= ClassID) = 1;
    features.y(features.y == ClassID) = 2;

    
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
    disp('Processing PCA');
    PCA_model = pca(kruskal_data.X,3);
    PCA_data = linproj(kruskal_data,PCA_model);

    % ppatterns see clusters.
    figure
    title('Clusters');
    ppatterns(PCA_data);  
end

