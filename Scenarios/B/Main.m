% Getting All Dataset
% This one will take a really long time.
if(exist('HOG_DATA.mat','file') == 0)
    disp('Reading all training and testing Datasets. Please be patient this is HUGE...');
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_01/');
    TSDATA_HOG_01 = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_02/');
    TSDATA_HOG_02 = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_03/');
    TSDATA_HOG_03 = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
    TSFolder.Path = TSFolder.Path(1);
    TSFolder.folder = TSFolder.folder(1);
    TSDATATesting_HOG_01 = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
    TSFolder.Path = TSFolder.Path(2);
    TSFolder.folder = TSFolder.folder(2);
    TSDATATesting_HOG_02 = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
    TSFolder.Path = TSFolder.Path(3);
    TSFolder.folder = TSFolder.folder(3);
    TSDATATesting_HOG_03 = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HueHist/GTSRB/Final_Training/HueHist/');
    TSDATA_Hue = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_Haar/GTSRB/Final_Training/Haar/');
    TSDATA_Haar = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HueHist/GTSRB/Final_Test/');
    TSFolder.Path = TSFolder.Path(1);
    TSFolder.folder = TSFolder.folder(1);
    TSDATATesting_Hue = ReadAllData(TSFolder);
    TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_Haar/GTSRB\Final_Test/');
    TSFolder.Path = TSFolder.Path(1);
    TSFolder.folder = TSFolder.folder(1);
    TSDATATesting_Haar = ReadAllData(TSFolder);

    TSDATATestingClass=xlsread('../../Dataset/GT-final_test_Class_Info.csv');
        
    % saving workspace for 1000x faster loading
    save HOG_DATA;
end
% -------------------------------------

% If we have file .mat already saved:
HOG = {'TSDATA_HOG_01' 'TSDATA_HOG_02' 'TSDATA_HOG_03'};
TestHOG = {'TSDATATesting_HOG_01' 'TSDATATesting_HOG_02' 'TSDATATesting_HOG_03'};

% Change this for varios tests.
% Which signal we want to discriminate?
ClassID = 12;
HOGid = 1;

TSBegginingPos = ClassID*210 + 1; %Signal Position Beggining Calculation
TSBegginingEnd = (ClassID+1)*210; %Signal Position Ending Calculation

[PCA_data,SelectedFeaturesPositions] = ScenaryA(HOG{HOGid},ClassID);
Testing_HOG_Dataset = load('HOG_DATA',TestHOG{HOGid});
Testing_HOG_Dataset = struct2cell(Testing_HOG_Dataset);
Testing_HOG_Dataset = Testing_HOG_Dataset{1};

% -------------------------------------
% Linear Classifiers.
LinearClassifiers(PCA_data,Testing_HOG_Dataset,SelectedFeaturesPositions,TSBegginingPos,TSBegginingEnd,ClassID,HOG{HOGid});

% Saving Training PCA for faster use.   
if(exist('TrainingPCA.mat','file') == 0)
    Training_PCA.writepos = 1;
    Training_PCA.Data(Training_PCA.writepos) = PCA_data;
    Training_PCA.Class = ClassID;
    Training_PCA.HOG = HOGid;
    Training_PCA.writepos = Training_PCA.writepos + 1;
    save('TrainingPCA.mat','Traning_PCA');
else
    Training_PCA.Data(Training_PCA.writepos) = PCA_data;
    Training_PCA.Class = ClassID;
    Training_PCA.writepos = Training_PCA.writepos + 1;
end

fileID = fopen('log.txt','a+');
fprintf(fileID,"\nFeatures Positions:\n");
for j=1:length(SelectedFeaturesPositions)
    fprintf(fileID,"%d\n",SelectedFeaturesPositions(j));
end
fclose(fileID);