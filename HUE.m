% Reading Hue Dataset

% Getting All Folders
if(exist('TSDATA','var') == 0)
    TSFolder = GetFolders('Dataset/GTSRB_Final_Training_HueHist/GTSRB/Final_Training/HueHist/');
    TSDATA = ReadAllData(TSFolder);
end

% Red Space ->  225 - 256 and 0 - 32
% Blue Space -> 128 - 192
% Yellow Space -> 32 - 79?

HueColorSpace.Red = zeros(length(TSDATA(:,1)),length(TSDATA(1,:)));
HueColorSpace.Blue = zeros(length(TSDATA(:,1)),length(TSDATA(1,:)));
HueColorSpace.Yellow = zeros(length(TSDATA(:,1)),length(TSDATA(1,:)));

for i=1:length(TSDATA(:,1))
   for j=1:length(TSDATA(1,:))
        HueColorSpace.Red(i,j) =  mean([TSDATA{i,j}(225:256);TSDATA{i,j}(1:32)]);
        HueColorSpace.Blue(i,j) =  mean(TSDATA{i,j}(128:192));
        HueColorSpace.Yellow(i,j) =  mean(TSDATA{i,j}(32:79));
   end
end