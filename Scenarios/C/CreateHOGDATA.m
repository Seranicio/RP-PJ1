function CreateHOGDATA()
    if(exist('HOG_DATA.mat','file') == 0)
        disp('Reading all HOG training and testing dataset. Please be patient this is a hude dataset');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_01/');
        TSDATA_HOG_01 = ReadAllData(TSFolder);
        disp('HOG01 Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_02/');
        TSDATA_HOG_02 = ReadAllData(TSFolder);
        disp('HOG02 Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_03/');
        TSDATA_HOG_03 = ReadAllData(TSFolder);
        disp('HOG03 Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_HueHist/GTSRB/Final_Training/HueHist/');
        TSDATA_Hue = ReadAllData(TSFolder);
        disp('Hue Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Training_Haar/GTSRB/Final_Training/Haar/');
        TSDATA_Haar = ReadAllData(TSFolder);
        disp('Haar Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
        TSFolder.Path = TSFolder.Path(1);
        TSFolder.folder = TSFolder.folder(1);
        TSDATATesting_HOG_01 = ReadAllData(TSFolder);
        disp('Testing HOG01 Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
        TSFolder.Path = TSFolder.Path(2);
        TSFolder.folder = TSFolder.folder(2);
        TSDATATesting_HOG_02 = ReadAllData(TSFolder);
        disp('Testing HOG02 Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
        TSFolder.Path = TSFolder.Path(3);
        TSFolder.folder = TSFolder.folder(3);
        TSDATATesting_HOG_03 = ReadAllData(TSFolder);
        disp('Testing HOG03 Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_HueHist/GTSRB/Final_Test/');
        TSDATATesting_Hue = ReadAllData(TSFolder);
        disp('Testing Hue Loaded');
        TSFolder = GetFolders('../../Dataset/GTSRB_Final_Test_Haar/GTSRB/Final_Test/');
        TSDATATesting_Haar = ReadAllData(TSFolder);
        disp('Testing Haar Loaded');
        TSDATATestingClass=xlsread('../../Dataset/GT-final_test_Class_Info.csv');
        disp('Testing Classes Loaded');
        % saving workspace for 1000x faster loading
        save('HOG_DATA','TSDATA_HOG_01','TSDATA_HOG_02','TSDATA_HOG_03','TSDATATesting_HOG_01','TSDATATesting_HOG_02','TSDATATesting_HOG_03','TSDATATesting_Haar','TSDATATesting_Hue','TSDATA_Hue','TSDATA_Haar','TSDATATestingClass');
    end
end

