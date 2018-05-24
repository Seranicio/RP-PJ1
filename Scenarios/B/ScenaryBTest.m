function FinalResults = ScenaryBTest(Unique_Classifier,Danger_Classifier,Derestrition_Classifier,Mandatory_Classifier,OtherProhibited_Classifier,Prohibited_Classifier);
    load('OrganizeFeatures.mat', 'TSDATATestingClass', 'TSDATATesting_HOG_01', 'TSDATATesting_HOG_02', 'TSDATATesting_HOG_03', 'TSDATATesting_Haar', 'TSDATATesting_Hue');
    % Reading Excel Info for which signal belong to class
    [Info.ClassIDs,Info.ClassName]=xlsread('../../Dataset/DataInfo.xlsx','ScenaryB');
    
    FinalResults.Class = zeros(1,length(TSDATATesting_Haar));
    FinalResults.Number = 1:1:length(TSDATATesting_Haar);
    % This outputs a new array where each sign belong to each class
    for i=1:length(Info.ClassName)
        aux = Info.ClassIDs(Info.ClassIDs(:,i) ~= -1,i);
        for j=1:length(aux)
            FinalResults.TSClass(TSDATATestingClass(:,7) == Info.ClassIDs(j,i)) = i;
        end
    end
    
    auxNumbers = 1:1:length(TSDATATesting_Haar);
    
    disp('Classify Unique Signs except No Entry Unique Sign');
    
    % % % % % % % % % % % % % % % % %
    %         Unique Signs.         %
    % % % % % % % % % % % % % % % % %
    ID = 6;
    
    for i=1:length(Unique_Classifier.Class)-1
        disp(strcat('Class nº',int2str(Unique_Classifier.Class(i))));     
        aux = Unique_Classifier.Operators(i);
        
        jointest = joinTestData(aux.Features);
        
        Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Unique_Classifier.Class(i),aux.SelectedClassifier); 
        
        positions =  find(Result_Class.Results < 0);
        FinalResults.Class(auxNumbers(positions)) = ID;
        
        %ERROR:
%         error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
%         correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
%         fprintf("ERROR: %d\n", error);
%         fprintf("Correct: %d\n" , correct);
        
        %Removing already classified
        [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
        clear joinaux jointest;
    end
    
    % % % % % % % % % % % % % % % % %
    %       No Entry Signs.         %
    % % % % % % % % % % % % % % % % %
    ID = 6;
    
    disp('Classify No Entry Signs');
    
    aux = Unique_Classifier.Operators(4);
        
    jointest = joinTestData(aux.Features);

    Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Unique_Classifier.Class(4),aux.SelectedClassifier); 

    positions =  find(Result_Class.Results < 0);

    FinalResults.Class(auxNumbers(positions)) = ID;

    %ERROR:
%     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
%     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
%     fprintf("ERROR: %d\n", error);
%     fprintf("Correct: %d\n" , correct);
    
    %Removing already classified
    [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
    clear joinaux jointest;
    
    % % % % % % % % % % % % % % % % %
    %         Danger Signs.         %
    % % % % % % % % % % % % % % % % %
    ID = 5;
    
    disp('Classify Danger Signs');
    
    aux = Danger_Classifier.Operators;
        
    jointest = joinTestData(aux.Features);

    Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Danger_Classifier.Class,aux.SelectedClassifier); 

    positions =  find(Result_Class.Results < 0);

    FinalResults.Class(auxNumbers(positions)) = ID;

    %ERROR:
%     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
%     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
%     fprintf("ERROR: %d\n", error);
%     fprintf("Correct: %d\n" , correct);
    
    %Removing already classified
    [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
    clear joinaux jointest;
    
    global Layout;
    
    if(Layout == 2)
        % % % % % % % % % % % % % % % % %
        %        Derestrition Signs.    %
        % % % % % % % % % % % % % % % % %
        ID = 4;

        disp('Classify Derestrition Signs');

        aux = Derestrition_Classifier.Operators;

        jointest = joinTestData(aux.Features);

        Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Derestrition_Classifier.Class,aux.SelectedClassifier); 

        positions =  find(Result_Class.Results < 0);

        FinalResults.Class(auxNumbers(positions)) = ID;

        %ERROR:
    %     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
    %     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
    %     fprintf("ERROR: %d\n", error);
    %     fprintf("Correct: %d\n" , correct);

        %Removing already classified
        [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
        clear joinaux jointest;
        
        % % % % % % % % % % % % % % % % %
        %         Mandatory Signs.      %
        % % % % % % % % % % % % % % % % %
        ID = 3;

        disp('Classify Mandatory Signs');

        aux = Mandatory_Classifier.Operators;

        jointest = joinTestData(aux.Features);

        Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Mandatory_Classifier.Class,aux.SelectedClassifier); 

        positions =  find(Result_Class.Results < 0);

        FinalResults.Class(auxNumbers(positions)) = ID;

        %ERROR:
    %     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
    %     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
    %     fprintf("ERROR: %d\n", error);
    %     fprintf("Correct: %d\n" , correct);

        %Removing already classified
        [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
        clear joinaux jointest;
    else
        % % % % % % % % % % % % % % % % %
        %         Mandatory Signs.      %
        % % % % % % % % % % % % % % % % %
        ID = 3;

        disp('Classify Mandatory Signs');

        aux = Mandatory_Classifier.Operators;

        jointest = joinTestData(aux.Features);

        Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Mandatory_Classifier.Class,aux.SelectedClassifier); 

        positions =  find(Result_Class.Results < 0);

        FinalResults.Class(auxNumbers(positions)) = ID;

        %ERROR:
    %     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
    %     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
    %     fprintf("ERROR: %d\n", error);
    %     fprintf("Correct: %d\n" , correct);

        %Removing already classified
        [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
        clear joinaux jointest;

        % % % % % % % % % % % % % % % % %
        %        Derestrition Signs.    %
        % % % % % % % % % % % % % % % % %
        ID = 4;

        disp('Classify Derestrition Signs');

        aux = Derestrition_Classifier.Operators;

        jointest = joinTestData(aux.Features);

        Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Derestrition_Classifier.Class,aux.SelectedClassifier); 

        positions =  find(Result_Class.Results < 0);

        FinalResults.Class(auxNumbers(positions)) = ID;

        %ERROR:
    %     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
    %     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
    %     fprintf("ERROR: %d\n", error);
    %     fprintf("Correct: %d\n" , correct);

        %Removing already classified
        [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
        clear joinaux jointest;
    end
    
    % % % % % % % % % % % % % % % % %
    %       Prohibited Signs.       %
    % % % % % % % % % % % % % % % % %
    ID = 1;
    
    disp('Classify Prohibited Signs');
    
    aux = Prohibited_Classifier.Operators;
        
    jointest = joinTestData(aux.Features);

    Result_Class = ScenaryBClassify(aux.PCA_model,aux.OthersMean,aux.HeroMean,aux.Covarience,aux.FishersWeights,jointest,TSDATATestingClass,aux.SelectedFeatures,Prohibited_Classifier.Class,aux.SelectedClassifier); 

    positions =  find(Result_Class.Results < 0);

    FinalResults.Class(auxNumbers(positions)) = ID;

    %ERROR:
%     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
%     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
%     fprintf("ERROR: %d\n", error);
%     fprintf("Correct: %d\n" , correct);
    
    %Removing already classified
    [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions);
    clear joinaux jointest;
     
    % Rest:
    
    ID = 2;
    
    FinalResults.Class(find(FinalResults.Class == 0)) = ID;
    
    %ERROR:
%     error = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) ~= ID));
%     correct = length(find(FinalResults.Class(:) == ID & FinalResults.TSClass(:) == ID));
%     fprintf("ERROR: %d\n", error);
%     fprintf("Correct: %d\n" , correct);
    
    % ------------------------------------------------------
    % Computing Results for Spec
    
    TP = 0;
    TN = 0;
    
    load('OrganizeFeatures.mat', 'TSDATATestingClass');
    
    new = zeros(1,length(FinalResults.Class));
    % This outputs a new array where each sign belong to each class
    for i=1:length(Info.ClassName)
        aux = Info.ClassIDs(Info.ClassIDs(:,i) ~= -1,i);
        for j=1:length(aux)
            new(TSDATATestingClass(:,7) == Info.ClassIDs(j,i)) = i;
        end
    end

    for i=1:length(FinalResults.Class)
        if(FinalResults.Class(i) == 0)
            disp("ERROR COMPUTING CLASSES");
            continue;
        end
        
        if(FinalResults.Class(i) == new(i))
            TP = TP +1;
        else
            TN = TN + 1;
        end
    end
    
    disp(TP);
    disp(TN);
    disp('Sens:');
    disp(TP / (TP + TN));
    
    function jointest = joinTestData(hardFeatures)
        joinaux = [];
        for k=1:length(hardFeatures)
            if(hardFeatures(k) == "HUE")
                joinaux = [joinaux;TSDATATesting_Hue{:}];
            elseif(hardFeatures(k) == "Haar")
                joinaux = [joinaux;TSDATATesting_Haar{:}];
            elseif(hardFeatures(k) == "HOG01")
                joinaux = [joinaux;TSDATATesting_HOG_01{:}];
            elseif(hardFeatures(k) == "HOG02")
                joinaux = [joinaux;TSDATATesting_HOG_02{:}];
            elseif(hardFeatures(k) == "HOG03")
                joinaux = [joinaux;TSDATATesting_HOG_03{:}];
            else
                disp('ERROR1');
                return;          
            end
        end
        jointest = cell(1,size(joinaux,2));
        for m=1:size(joinaux,2)
            jointest{m} = joinaux(:,m);
        end
    end

    function  [TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,auxNumbers,TSDATATestingClass] = RemoveClassifiedData(TSDATATesting_Haar,TSDATATesting_Hue,TSDATATesting_HOG_01,TSDATATesting_HOG_02,TSDATATesting_HOG_03,TSDATATestingClass,auxNumbers,positions)
        disp('.........Removing Already Classified Test Classes.........');
        TSDATATestingClass(positions,:) = [];
        TSDATATesting_Haar(positions) = [];
        TSDATATesting_Hue(positions) = [];
        TSDATATesting_HOG_01(positions) = [];
        TSDATATesting_HOG_02(positions) = [];
        TSDATATesting_HOG_03(positions) = [];
        auxNumbers(positions) = [];
    end
end

