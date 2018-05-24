                            % % % % % % % % % % % % % % % % % % 
                            % % % % % Scenary B Tree % % % %  % 
                            % % % % % % % % % % % % % % % % % % 
format long g;

disp('Reading Scenario B Classes from Excel...');
% Reading Excel Info for which signal belong to class
[Info.ClassIDs,Info.ClassName]=xlsread('../../Dataset/DataInfo.xlsx','ScenaryB');

% % Organizing Features to array.
if(exist('B/OrganizeFeatures.mat','file') == 0)
    disp('OrganizeFeatures.mat doesnt exists. Creating file for hude performance boost...');
    if(exist('B/HOG_DATA.mat','file') == 0)
        disp('Creating HOG_DATA.mat file');
        CreateHOGDATA();
    end
    disp('Reading HOG_DATA.mat');
    load B/HOG_DATA.mat;
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
    if(exist('B/HOG_DATA.mat','file') > 1)
        delete HOG_DATA.mat;
    end
    save('OrganizeFeatures.mat','TSDATA_HOG_01','TSDATA_HOG_02','TSDATA_HOG_03','TSDATA_Hue','TSDATA_Haar','features_HOG_01','features_HOG_02','features_HOG_03','features_Hue','features_Haar','TSDATATesting_HOG_01','TSDATATesting_HOG_02','TSDATATesting_HOG_03','TSDATATesting_Hue','TSDATATesting_Haar','TSDATATestingClass');
    disp('OrganizeFeatures.mat created');
end

disp('Load OrganizeFeatures.mat');
load OrganizeFeatures.mat;

% Creating Variables for Classifier Storing.
Unique_Classifier.Class = Info.ClassIDs(find(Info.ClassIDs(:,6) ~= -1),6);
Danger_Classifier.Class = Info.ClassIDs(find(Info.ClassIDs(:,5) ~= -1),5);
Derestrition_Classifier.Class = Info.ClassIDs(find(Info.ClassIDs(:,4) ~= -1),4);
Mandatory_Classifier.Class = Info.ClassIDs(find(Info.ClassIDs(:,3) ~= -1),3);
OtherProhibited_Classifier.Class = Info.ClassIDs(find(Info.ClassIDs(:,2) ~= -1),2);
Prohibited_Classifier.Class = Info.ClassIDs(find(Info.ClassIDs(:,1) ~= -1),1);

disp('% % % % % % % % % % % % % % % % %');
disp('%         Unique Signs.         %');
disp('% % % % % % % % % % % % % % % % %');

disp('Using Scenary A for unique Signs Classify');

HOG = {'TSDATA_HOG_01' 'TSDATA_HOG_02' 'TSDATA_HOG_03'};
TestHOG = {'TSDATATesting_HOG_01' 'TSDATATesting_HOG_02' 'TSDATATesting_HOG_03'};

ClassID = [12,13,14];

for i=1:length(ClassID)
    disp(strcat('Training Classifier Unique Class nº ',int2str(ClassID(i))));
    
    if(i == 1)
        [PCA_data,PCA_model,SelectedFeaturesPositions] = ScenaryA(features_HOG_03,ClassID(i));
    else
        [PCA_data,PCA_model,SelectedFeaturesPositions] = ScenaryA(features_HOG_02,ClassID(i));
    end

    % -------------------------------------
    % Linear Classifiers.
    if(i==1)
        Result = LinearClassifiers(PCA_data,PCA_model,TSDATATestingClass,TSDATATesting_HOG_03,SelectedFeaturesPositions,ClassID(i));
        Result.Features = "HOG03";
    else
        Result = LinearClassifiers(PCA_data,PCA_model,TSDATATestingClass,TSDATATesting_HOG_02,SelectedFeaturesPositions,ClassID(i)); 
        Result.Features = "HOG02";
    end
    Unique_Classifier.Operators(i) = Result;
    
    %Removing Already Training Data.
    [features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,ClassID(i));
end

disp('% % % % % % % % % % % % % % % % %');
disp('%        No Entry Signs.        %');
disp('% % % % % % % % % % % % % % % % %');

disp('Training Classifer No Entry Sign Class');

joinfeatures.X = [features_Hue.X;features_Haar.X;features_HOG_03.X];
joinfeatures.y = features_Hue.y;

joinaux = [TSDATATesting_Hue{:};TSDATATesting_Haar{:};TSDATATesting_HOG_03{:}];
jointest = cell(1,size(joinaux,2));
for i=1:size(joinaux,2)
    jointest{i} = joinaux(:,i);
end
    
[PCA_data,PCA_model,SelectedFeaturesPositions] = ScenaryA(joinfeatures,Unique_Classifier.Class(4));

% -------------------------------------
% Linear Classifiers.
Result = LinearClassifiers(PCA_data,PCA_model,TSDATATestingClass,jointest,SelectedFeaturesPositions,Unique_Classifier.Class(4));
Result.Features = ["HUE","Haar","HOG03"];

Unique_Classifier.Operators(4) = Result;

[features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,Unique_Classifier.Class(4));


disp('% % % % % % % % % % % % % % % % %');
disp('%         Danger Signs.         %');
disp('% % % % % % % % % % % % % % % % %');

disp('Training Classifier Danger Sign Class');

Result = TrainClass(features_HOG_03,Danger_Classifier,TSDATATesting_HOG_03,"HOG03",TSDATATestingClass);

Danger_Classifier.Operators = Result;

%Removing Already Training Data.
[features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,Danger_Classifier.Class);

global Layout;

if(Layout == 2)
        disp('% % % % % % % % % % % % % % % % %');
    disp('%      Derestrition Signs.      %');
    disp('% % % % % % % % % % % % % % % % %');

    disp('Training Classifer Derestrition Sign Class');

    joinfeatures.X = [features_Hue.X;features_Haar.X;features_HOG_02.X];
    joinfeatures.y = features_Hue.y;

    joinaux = [TSDATATesting_Hue{:};TSDATATesting_Haar{:};TSDATATesting_HOG_02{:}];
    jointest = cell(1,size(joinaux,2));
    for i=1:size(joinaux,2)
        jointest{i} = joinaux(:,i);
    end

    Result = TrainClass(joinfeatures,Derestrition_Classifier,jointest,["HUE","Haar","HOG02"],TSDATATestingClass);

    Derestrition_Classifier.Operators = Result;

    [features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,Derestrition_Classifier.Class);
    
    disp('% % % % % % % % % % % % % % % % %');
    disp('%         Mandatory Signs.      %');
    disp('% % % % % % % % % % % % % % % % %');

    disp('Training Classifer Mandatory Sign Class');

    joinfeatures.X = [features_Hue.X;features_Haar.X;features_HOG_01.X];
    joinfeatures.y = features_Hue.y;

    joinaux = [TSDATATesting_Hue{:};TSDATATesting_Haar{:};TSDATATesting_HOG_01{:}];
    jointest = cell(1,size(joinaux,2));
    for i=1:size(joinaux,2)
        jointest{i} = joinaux(:,i);
    end

    Result = TrainClass(joinfeatures,Mandatory_Classifier,jointest,["HUE","Haar","HOG01"],TSDATATestingClass);

    Mandatory_Classifier.Operators = Result;

    %Removing Already Training Data.
    [features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,Mandatory_Classifier.Class);
else
    disp('% % % % % % % % % % % % % % % % %');
    disp('%         Mandatory Signs.      %');
    disp('% % % % % % % % % % % % % % % % %');

    disp('Training Classifer Mandatory Sign Class');

    joinfeatures.X = [features_Hue.X;features_Haar.X;features_HOG_01.X];
    joinfeatures.y = features_Hue.y;

    joinaux = [TSDATATesting_Hue{:};TSDATATesting_Haar{:};TSDATATesting_HOG_01{:}];
    jointest = cell(1,size(joinaux,2));
    for i=1:size(joinaux,2)
        jointest{i} = joinaux(:,i);
    end

    Result = TrainClass(joinfeatures,Mandatory_Classifier,jointest,["HUE","Haar","HOG01"],TSDATATestingClass);

    Mandatory_Classifier.Operators = Result;

    %Removing Already Training Data.
    [features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,Mandatory_Classifier.Class);

    disp('% % % % % % % % % % % % % % % % %');
    disp('%      Derestrition Signs.      %');
    disp('% % % % % % % % % % % % % % % % %');

    disp('Training Classifer Derestrition Sign Class');

    joinfeatures.X = [features_Hue.X;features_Haar.X;features_HOG_02.X];
    joinfeatures.y = features_Hue.y;

    joinaux = [TSDATATesting_Hue{:};TSDATATesting_Haar{:};TSDATATesting_HOG_02{:}];
    jointest = cell(1,size(joinaux,2));
    for i=1:size(joinaux,2)
        jointest{i} = joinaux(:,i);
    end

    Result = TrainClass(joinfeatures,Derestrition_Classifier,jointest,["HUE","Haar","HOG02"],TSDATATestingClass);

    Derestrition_Classifier.Operators = Result;

    [features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,Derestrition_Classifier.Class);

end

disp('% % % % % % % % % % % % % % % % %');
disp('%    Prohibited Speed Signs.    %');
disp('% % % % % % % % % % % % % % % % %');

disp('Training Classifer Prohibited Speed Sign Class');

joinfeatures.X = [features_Hue.X;features_Haar.X;features_HOG_02.X];
joinfeatures.y = features_Hue.y;

joinaux = [TSDATATesting_Hue{:};TSDATATesting_Haar{:};TSDATATesting_HOG_02{:}];
jointest = cell(1,size(joinaux,2));
for i=1:size(joinaux,2)
    jointest{i} = joinaux(:,i);
end

Result = TrainClass(joinfeatures,Prohibited_Classifier,jointest,["HUE","Haar","HOG02"],TSDATATestingClass);

Prohibited_Classifier.Operators = Result;

disp('% % % % % % % % % % % % % % % % %');
disp('% Other Prohibited Speed Signs. %');
disp('% % % % % % % % % % % % % % % % %');

disp('Training Classifer Prohibited Speed Sign Class');

joinfeatures.X = [features_Hue.X;features_Haar.X;features_HOG_03.X];
joinfeatures.y = features_Hue.y;

joinaux = [TSDATATesting_Hue{:};TSDATATesting_Haar{:};TSDATATesting_HOG_03{:}];
jointest = cell(1,size(joinaux,2));
for i=1:size(joinaux,2)
    jointest{i} = joinaux(:,i);
end
Result = TrainClass(joinfeatures,OtherProhibited_Classifier,jointest,["HUE","Haar","HOG03"],TSDATATestingClass);

OtherProhibited_Classifier.Operators = Result;

[features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,OtherProhibited_Classifier.Class);

% --------------------------------------------------------------------

disp('Training DONE...');
disp('Testing...');

% save if you wanna skip training
save('skiptraining','Unique_Classifier','Danger_Classifier','Derestrition_Classifier','Mandatory_Classifier','OtherProhibited_Classifier','Prohibited_Classifier');

% Testing...
ScenaryBTest(Unique_Classifier,Danger_Classifier,Derestrition_Classifier,Mandatory_Classifier,OtherProhibited_Classifier,Prohibited_Classifier);

function Result = TrainClass(features_train,whatClass,SelectedFeaturesTest,String,TSDATATestingClass)
    [PCA_data,PCA_model,SelectedFeaturesPositions] = ScenaryA(features_train,whatClass.Class);

    % -------------------------------------
    % Linear Classifiers.
    Result = LinearClassifiers(PCA_data,PCA_model,TSDATATestingClass,SelectedFeaturesTest,SelectedFeaturesPositions,whatClass.Class);
    Result.Features = String;
end

function  [features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue] = RemoveClassifiedData(features_HOG_01,features_HOG_02,features_HOG_03,features_Haar,features_Hue,ClassID)
    disp('.........Removing Already Classified Classes.........');
    for i=1:length(ClassID)
        features_HOG_01.X = features_HOG_01.X(:,find(features_HOG_01.y ~= ClassID(i)));
        features_HOG_01.y = features_HOG_01.y(find(features_HOG_01.y ~= ClassID(i)));
        features_HOG_02.X = features_HOG_02.X(:,find(features_HOG_02.y ~= ClassID(i)));
        features_HOG_02.y = features_HOG_02.y(find(features_HOG_02.y ~= ClassID(i)));
        features_HOG_03.X = features_HOG_03.X(:,find(features_HOG_03.y ~= ClassID(i)));
        features_HOG_03.y = features_HOG_03.y(find(features_HOG_03.y ~= ClassID(i)));
        features_Haar.X = features_Haar.X(:,find(features_Haar.y ~= ClassID(i)));
        features_Haar.y = features_Haar.y(find(features_Haar.y ~= ClassID(i)));
        features_Hue.X = features_Hue.X(:,find(features_Hue.y ~= ClassID(i)));
        features_Hue.y = features_Hue.y(find(features_Hue.y ~= ClassID(i)));
    end
end