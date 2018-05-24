% Getting All HOG Folders
% This one will take a really long time.
CreateHOGDATA()

% -------------------------------------

% If we have file .mat already saved:
HOG = {'TSDATA_HOG_01' 'TSDATA_HOG_02' 'TSDATA_HOG_03'};
TestHOG = {'TSDATATesting_HOG_01' 'TSDATATesting_HOG_02' 'TSDATATesting_HOG_03'};

% Change this for varios tests.
% Which signal we want to discriminate?
ClassID = 14; % Traffic Sign Stop
HOGid = TypeHog; 


if(SceneryARunDefault == 1)
    TSBegginingPos = ClassID*210 + 1; %Signal Position Beggining Calculation
    TSBegginingEnd = (ClassID+1)*210; %Signal Position Ending Calculation

    [PCA_data,PCA_model,SelectedFeaturesPositions] = ScenaryA(HOG{HOGid},ClassID);
    Testing_HOG_Dataset = load('HOG_DATA',TestHOG{HOGid});
    Testing_HOG_Dataset = struct2cell(Testing_HOG_Dataset);
    Testing_HOG_Dataset = Testing_HOG_Dataset{1};

    % -------------------------------------
    % Linear Classifiers.
    LinearClassifiers(PCA_data,PCA_model,Testing_HOG_Dataset,SelectedFeaturesPositions,TSBegginingPos,TSBegginingEnd,ClassID,0);
else
    HogPath = ScenaryAHOG_location;
    fileHog = ScenaryAHOG_File;
    
    TSBegginingPos = ClassID*210 + 1; %Signal Position Beggining Calculation
    TSBegginingEnd = (ClassID+1)*210; %Signal Position Ending Calculation
    
    [PCA_data,PCA_model,SelectedFeaturesPositions] = ScenaryA(HOG{HOGid},ClassID);
    
    aux = importdata(strcat(HogPath,fileHog));
    aux = aux';
    Testing_HOG_Dataset{1} = aux;
    
    LinearClassifiers(PCA_data,PCA_model,Testing_HOG_Dataset,SelectedFeaturesPositions,TSBegginingPos,TSBegginingEnd,ClassID,1); 
end
