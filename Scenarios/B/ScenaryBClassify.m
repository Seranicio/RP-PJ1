function  outResult = ScenaryBClassify(PCA_model,meanOthers,meanHero,C,FishersWeight,Testing_HOG,TSDATATestingClass,SelectedFeaturesPositions,ObjectID,LinearClassifier)

    mOthers = meanOthers; %m1
    mStop = meanHero;     %m2

    disp('Doing Test Dataset Classification...');

    for j=1:size(Testing_HOG,2)
        for i=1:length(SelectedFeaturesPositions)
            TestingPCA.X(i,j) =  Testing_HOG{j}(SelectedFeaturesPositions(i));
        end
        if(ismember(TSDATATestingClass(j,7),ObjectID))
            TestingPCA.y(j) = 2;
        else
            TestingPCA.y(j) = 1;
        end
    end
    
    TestingPCA.dim = length(SelectedFeaturesPositions);
    TestingPCA.num_data = size(Testing_HOG,2);

    TestingPCA = linproj(TestingPCA,PCA_model);
    
    
%     figure;
%     title('Clusters');
%     ppatterns(TestingPCA);
    
    % Classifiers:

    % % % % % % % % % % % % % % % % % % % % % 
    % Euclidean minimum distance classifier %
    % % % % % % % % % % % % % % % % % % % % % 
    
    if(LinearClassifier(1) == 1)
        % 1 - TS Others Class | 2 - TS Stop Class
        for i=1:size(TestingPCA.X,2)
            Euclidean_Results.Results(i) = Euclideandx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)]);
        end

        Euclidean_Results.Class = TestingPCA.y;
        outResult = Euclidean_Results;

        clear i j;
        % Sensitivity and Specificity:
        disp('Calculating Euclidean Sensitivity and Specificity');
        [Euclidean_A_Sensitivity,Euclidean_A_Specificity] = Sensitivity_Specificity(Euclidean_Results);
        disp("Euclidean Sensitivity: " + Euclidean_A_Sensitivity + " | Euclidean Specificity: " +Euclidean_A_Specificity);
        
        % Drawing line 
    %     aux = -0.5 * (mOthers' * mOthers);
    %     aux2 = -0.5 * (mStop' * mStop);
    %     b = aux - aux2;
    %     w = [mOthers(1)-mStop(1) mOthers(2)-mStop(2) mOthers(3)-mStop(3)];
    %     figure;title('Euclidean');ppatterns(PCA_data); pline(w,b);

    elseif(LinearClassifier(1) == 2)
        % % % % % % % % % % % % % % % % % % % % % % 
        % Mahalanobis minimum distance classifier %
        % % % % % % % % % % % % % % % % % % % % % % 

        for i=1:size(TestingPCA.X,2)
            Mahalanobis_Results.Results(i) = Mahalanobisx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],C);
        end

        Mahalanobis_Results.Class = TestingPCA.y;
        outResult = Mahalanobis_Results;
        % Sensitivity and Specificity:
        disp('Calculating Mahalanobis Sensitivity and Specificity');
        [Mahalanobis_A_Sensitivity,Mahalanobis_A_Specificity] = Sensitivity_Specificity(Mahalanobis_Results);
        disp("Mahalanobis Sensitivity: " + Mahalanobis_A_Sensitivity + " | Mahalanobis Specificity: " +Mahalanobis_A_Specificity);

        % Drawing line 
%         aux = -0.5 * mOthers'* C * mOthers;
%         aux2 = -0.5 * mStop'* C * mStop;
%         b = aux - aux2;
%         w = [mOthers(1)-mStop(1) mOthers(2)-mStop(2) mOthers(3)-mStop(3)]*C;
%         figure;title('Mahalanobis'); ppatterns(PCA_data); pline(w,b);

    else
        % % % % % % % % % % % % % % % % % % % % % % 
        %        FISHER Linear Discriminant       %
        % % % % % % % % % % % % % % % % % % % % % % 

        disp('Fisher Linear Discriminant...');

        for i=1:size(TestingPCA.X,2)
            Fisher_Results.Results(i) = FisherClassify(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],FishersWeight);
        end

        Fisher_Results.Class = TestingPCA.y;
        outResult = Fisher_Results;
        
        % Sensitivity and Specificity:
        disp('Calculating Mahalanobis Sensitivity and Specificity');
        [Fisher_A_Sensitivity,Fisher_A_Specificity] = Sensitivity_Specificity(Fisher_Results);
        disp("Fisher Sensitivity: " + Fisher_A_Sensitivity + " | Fisher Specificity: " +Fisher_A_Specificity);
    end
    
    function out = Euclideandx1_x2(matrix1,matrix2,valueMatrix)
        aux = [matrix1(1)-matrix2(1) matrix1(2)-matrix2(2) matrix1(3)-matrix2(3)];
        aux2 = valueMatrix - (0.5 * (matrix1 + matrix2));
        out = aux * aux2;
    end

    function out = Mahalanobisx1_x2(matrix1,matrix2,valueMatrix,CovarianceMatrix)
        aux = (matrix1 - matrix2)' *CovarianceMatrix;
        aux2 = valueMatrix  -  (0.5 * (matrix1 + matrix2));
        out = aux * aux2;
    end

    function out = FisherClassify(matrix1,matrix2,valueMatrix,wT)
        aux = wT * valueMatrix;
        upper_1 = wT * matrix1;
        upper_2 = wT * matrix2;
        sub = upper_1 + upper_2;
        div = sub/2;

        out = aux - div;
    end
end

