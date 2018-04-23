function [PCA_data,kruskal_data,SelectedFeatures] = ScenaryA(HOG)
%SCENARYA Summary of this function goes here
%   Detailed explanation goes here
    disp(strcat('Analizing...',HOG));
    disp('Loading data...');
    HOG = load('HOG_DATA2.mat',HOG);
    HOG = struct2cell(HOG);
    HOG = HOG{1};

    numfeatures = length(HOG{1,1});
    numfiles = size(HOG,1) * size(HOG,2);

    disp('Organizing data... This takes a while...');
    disp('PC: *Sips coffee* ');
    disp('PC: Lets do This...');
    features.X = zeros(numfeatures,numfiles);

    % HOG_01 : Run and get a sip of coffee it's gonna take a while.
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
    TSstop_beggining = ( size(HOG,2) * 14 ) + 1; %15 is the folder 15 - 1 because... bla bla bla
    TSstop_final = TSstop_beggining + size(HOG,2) - 1;
    features.y(1,1:numfiles) = 1;
    features.y(TSstop_beggining:TSstop_final) = 2;

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
    model = pca(kruskal_data.X,3);
    PCA_data = linproj(kruskal_data,model);

    % ppatterns see clusters.
%     figure
%     ppatterns(PCA_data);
end

