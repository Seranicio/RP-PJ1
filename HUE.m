% Reading Hue Dataset

% Getting All Folders
if(exist('TSDATA','var') == 0)
    TSFolder = GetFolders('Dataset/GTSRB_Final_Training_HueHist/GTSRB/Final_Training/HueHist/');
    TSDATA = ReadAllData(TSFolder);
end


MeanArray = zeros(length(TSDATA(:,1)),length(TSDATA(1,:)));

for i=1:length(TSDATA(:,1))
   for j=1:length(TSDATA(1,:))
       MeanArray(i,j) = mean(TSDATA{i,j});
   end
end