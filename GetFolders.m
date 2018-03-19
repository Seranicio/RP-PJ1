function TSFolderFinal = GetFolders(location)
    TSFolder=dir(location);
    TSFolder=TSFolder(~ismember({TSFolder.name},{'.','..'}));

    for i=1:length(TSFolder)
        aux = "Dataset/GTSRB_Final_Training_HueHist/GTSRB/Final_Training/HueHist/" + TSFolder(i).name;
        aux = char(aux);
        TSFolderFinal.Path{i} = aux;
        TSFolderFinal.folder{i}=dir(aux);
        TSFolderFinal.folder{i}=TSFolderFinal.folder{i}(~ismember({TSFolderFinal.folder{i}.name},{'.','..'}));
    end

    TSFolderFinal.folder=TSFolderFinal.folder';
    TSFolderFinal.Path = TSFolderFinal.Path';
    
    % TSIndex = strsplit(TSIndex(1),'-');
end

