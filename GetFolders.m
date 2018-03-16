function TSFolderFinal = GetFolders(location)
    TSFolder=dir(location);
    TSFolder=TSFolder(~ismember({TSFolder.name},{'.','..'}));

    for i=1:length(TSFolder)
        aux = "Dataset/GTSRB_Final_Training_HueHist/GTSRB/Final_Training/HueHist/" + TSFolder(i).name;
        aux = char(aux);
        TSFolderFinal.folder{i}=dir(aux);
        TSFolderFinal.folder{i}=TSFolderFinal.folder{i}(~ismember({TSFolderFinal.folder{i}.name},{'.','..'}));
    end

    TSFolderFinal.folder=TSFolderFinal.folder';

    %Reading Folder Index
    TSIndex = importdata('Traffic Sign Folder Index.txt');
    for i=1:length(TSIndex)
        aux = strsplit(TSIndex{i},'-');
        TSFolderFinal.name{i} = aux{2};
    end
    TSFolderFinal.name = TSFolderFinal.name';
    % TSIndex = strsplit(TSIndex(1),'-');
end

