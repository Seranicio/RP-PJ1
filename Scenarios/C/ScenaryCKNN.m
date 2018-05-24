                            % % % % % % % % % % % % % % % % % % 
                            % % % % % % Scenary C % % % % % % %
                            % % % % % % % % % % % % % % % % % % 
format long g; 

% Reading Test Dataset
if(exist('OrganizeFeatures.mat','file') == 0)
    disp('OrganizeFeatures.mat doesnt exists. Creating file for hude performance boost...');
    if(exist('HOG_DATA.mat','file') == 0)
        disp('Creating HOG_DATA.mat file');
        CreateHOGDATA();
    end
    disp('Reading HOG_DATA.mat');
    load HOG_DATA.mat;
    numfiles = size(TSDATA_HOG_02,1) * size(TSDATA_HOG_02,2);

    % Organizing Features to array.
    disp('Organizing all features to array and assigning each class. Takes a white too...');
    disp('HOG 01...');
    features_HOG_01 = OrganizeStruct(TSDATA_HOG_01,length(TSDATA_HOG_01{1,1}),numfiles);
    disp('HOG 02...');
    features_HOG_02 = OrganizeStruct(TSDATA_HOG_02,length(TSDATA_HOG_02{1,1}),numfiles);
    disp('HOG 03...');
    features_HOG_03 = OrganizeStruct(TSDATA_HOG_03,length(TSDATA_HOG_03{1,1}),numfiles);
    
    numfiles = size(TSDATA_Hue,1) * size(TSDATA_Hue,2);
    
    disp('Hue...');
    features_Hue = OrganizeStruct(TSDATA_Hue,length(TSDATA_Hue{1}),numfiles);
    
    numfiles = size(TSDATA_Haar,1) * size(TSDATA_Haar,2);
    
    disp('Haar...');
    features_Haar = OrganizeStruct(TSDATA_Haar,length(TSDATA_Haar{1}),numfiles);

    clear HOG_DATA.mat;
    clear numfiles;
    if(exist('HOG_DATA.mat','file') > 1)
        delete HOG_DATA.mat;
    end
    save('OrganizeFeatures.mat','TSDATA_HOG_01','TSDATA_HOG_02','TSDATA_HOG_03','TSDATA_Hue','TSDATA_Haar','features_HOG_01','features_HOG_02','features_HOG_03','features_Hue','features_Haar','TSDATATesting_HOG_01','TSDATATesting_HOG_02','TSDATATesting_HOG_03','TSDATATesting_Hue','TSDATATesting_Haar','TSDATATestingClass');
    disp('OrganizeFeatures.mat created');
end

global SceneryCRunDefault;
if(SceneryCRunDefault == 1)
    HOGType = input('Which HOG u want to run?\n 1 - HOG01 | 2 - HOG02 | 3 - HOG03\nChoose: ');
end

% Loading All Features
disp('Loading OrganizeFeatures.mat Data...');
load OrganizeFeatures.mat;

if(HOGType == 1)
%     disp('HOG1');
    features_all.X = [features_HOG_01.X;features_Hue.X;features_Haar.X];
    features_all.y = features_HOG_01.y;
elseif(HOGType ==2)
%     disp('HOG2');
    features_all.X = [features_HOG_02.X;features_Hue.X;features_Haar.X];
    features_all.y = features_HOG_02.y;
else
%     disp('HOG3');
    features_all.X = [features_HOG_03.X;features_Hue.X;features_Haar.X];
    features_all.y = features_HOG_03.y;
end

randomDataPositions = [];
% doing 30% 
for i=1:43 % 43 Classes
    randomDataPositions = [randomDataPositions randperm(210,210*0.3) + (210 * (i-1))];
end

features_test.X = features_all.X(:,randomDataPositions);
features_test.y = features_all.y(:,randomDataPositions);
features_test.num_data = length(randomDataPositions);
features_test.dim = size(features_test.X,1);

features_all.X(:,randomDataPositions) = [];
features_all.y(:,randomDataPositions) = [];

numfeatures = size(features_all.X,1);
numfiles = size(features_all.X,2);

% Quick fix because i think it pca/lda cannot have class '0'.
features_all.y = features_all.y(:) + 1;
features_all.y = features_all.y';

disp('Processing Kruskal-Wallis...');
% Kruskal - Wallis
rank = cell(numfeatures,2);
for i=1:numfeatures
    [p,atab,stats] = kruskalwallis(features_all.X(i,:)',features_all.y,'off');
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
SelectedFeaturesPositions = maxPositions;

disp('Redudand data removed');

for i=1 : length(maxPositions)
    kruskal_data.X(i,:) = features_all.X(maxPositions(i),:);
end

kruskal_data.y = features_all.y;
kruskal_data.dim = numfeatures;
kruskal_data.num_data = numfiles;


% PCA
% PCA_model = lda(kruskal_data);
if(Analysis == 1)
    % PCA
    disp('Processing PCA');
    PCA_model = pca(kruskal_data.X);
else
    % PCA
    disp('Processing LDA');
    PCA_model = lda(kruskal_data);
end
PCA_data = linproj(kruskal_data,PCA_model);
PCA_data.dim = length(SelectedFeaturesPositions);
PCA_data.num_data = numfiles;

% ppatterns see clusters.
figure
title('Clusters');
ppatterns(PCA_data);  

% k-NN Classifier (k-Nearest Neightboors)
disp('------------k-NN Classifier------------');
disp('Loading Testing Dataset');

for j=1:size(features_test.X,2)
    for i=1:length(SelectedFeaturesPositions)
        TestingPCA.X(i,j) =  features_test.X(SelectedFeaturesPositions(i),j);
    end
end

TestingPCA.y = features_test.y;

TestingPCA = linproj(TestingPCA,PCA_model);

TestingPCA.dim = length(SelectedFeaturesPositions);
TestingPCA.num_data = size(TestingPCA.X,2);

% KNN Classifier
kpoints = [1,5,11,25,101];
spec = zeros(1,length(kpoints));

disp('Training KNN');

for i=1:length(kpoints)
    fprintf("K = %d\n",kpoints(i));
    classification_results = KNNClassifier(PCA_data,TestingPCA,kpoints(i));

    % Calculates KNNResults
    spec(i) = CalculateKNNResults(classification_results,features_test);
end


best = max(spec);
best_pos = find(spec == best);
K = kpoints(best_pos);
fprintf("Best K = %d\n",K);
disp('Using Test data');

if (SceneryCRunDefault == 1)
    if(HOGType == 1)
        TSDATATesting = [TSDATATesting_HOG_01{:};TSDATATesting_Hue{:};TSDATATesting_Haar{:}];
    elseif(HOGType == 2)
        TSDATATesting = [TSDATATesting_HOG_02{:};TSDATATesting_Hue{:};TSDATATesting_Haar{:}];
    else
        TSDATATesting = [TSDATATesting_HOG_03{:};TSDATATesting_Hue{:};TSDATATesting_Haar{:}];
    end
    
    for j=1:size(TSDATATesting,2)
        for i=1:length(SelectedFeaturesPositions)
            TestingPCA.X(i,j) =  TSDATATesting(SelectedFeaturesPositions(i),j);
        end
    end

    TestingPCA.y = TSDATATestingClass(:,7);
    TestingPCA.y = TestingPCA.y';

    TestingPCA = linproj(TestingPCA,PCA_model);

    TestingPCA.dim = length(SelectedFeaturesPositions);
    TestingPCA.num_data = size(TSDATATesting,2);

    classification_results = KNNClassifier(PCA_data,TestingPCA,K);

    % Calculates KNNResults
    Final_Spec = CalculateKNNResults(classification_results,TSDATATestingClass);
else
    disp('Reading Inputed File');
    aux = importdata(strcat(ScenaryCHOG_location,ScenaryCHOG_File));
    Testing_HOG_Dataset{1} = aux;
    
    aux = importdata(strcat(ScenaryCHue_location,ScenaryCHue_File));
    Testing_Hue_Dataset{1} = aux;
    
    aux = importdata(strcat(ScenaryCHaar_location,ScenaryCHaar_File));
    Testing_Haar_Dataset{1} = aux;
    
    TSDATATesting = [Testing_HOG_Dataset{1};Testing_Hue_Dataset{1};Testing_Haar_Dataset{1}];
    
    for j=1:size(TSDATATesting,2)
        for i=1:length(SelectedFeaturesPositions)
            TestingPCA.X(i,j) =  TSDATATesting(SelectedFeaturesPositions(i),j);
        end
        if (SceneryCRunDefault == 0)
            TestingPCA.y(j) = 0;
        end
    end
    
    TestingPCA.y = features_test.y;

    TestingPCA = linproj(TestingPCA,PCA_model);

    TestingPCA.dim = length(SelectedFeaturesPositions);
    TestingPCA.num_data = size(TSDATATesting,2);
  
    classification_results = KNNClassifier(PCA_data,TestingPCA,K);
    whichclass = classification_results(1);
    fprintf("KNN says this sign is Class %d\n",whichclass);
end