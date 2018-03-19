function TSDATA = ReadAllData(TSFolder)
%READALLDATA Summary of this function goes here
    TSDATA = cell(length(TSFolder.Path),length(TSFolder.folder{1}));

    % Takes a while
    % Reading All Data
    for j=1:length(TSFolder.Path)
        pathaux = strcat(TSFolder.Path{j},'/');
        for i=1:length(TSFolder.folder{1})
            TSDATA{j,i} = importdata(strcat(pathaux,TSFolder.folder{1,1}(i).name));
        end
    end
end

