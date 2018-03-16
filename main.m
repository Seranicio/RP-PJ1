% Reading Hue Dataset
TSFolder=dir('Dataset/GTSRB_Final_Training_HueHist/GTSRB/Final_Training/HueHist');
TSFolder=TSFolder(~ismember({TSFolder.name},{'.','..'}));

