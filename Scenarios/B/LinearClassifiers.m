function out = LinearClassifiers(PCA_data,PCA_model,TSDATATestingClass,Testing_HOG,SelectedFeaturesPositions,ObjectID)
%     load('HOG_DATA','TSDATATestingClass');

    % Classifiers:

    % % % % % % % % % % % % % % % % % % % % % 
    % Euclidean minimum distance classifier %
    % % % % % % % % % % % % % % % % % % % % % 

    % Dimensionality = 3;
    % x = [feature1;feature2;feature3];
    % Classes -> 2 -> Traffic Stop Sign and Others.

    disp('Calculating means for Classification...');
    
    mean_TSothersF1 = mean(PCA_data.X(1,PCA_data.y == 1));
    mean_TSothersF2 = mean(PCA_data.X(2,PCA_data.y == 1));
    mean_TSothersF3 = mean(PCA_data.X(3,PCA_data.y == 1));
    mean_TSStopF1 = mean(PCA_data.X(1,PCA_data.y == 2));
    mean_TSStopF2 = mean(PCA_data.X(2,PCA_data.y == 2));
    mean_TSStopF3 = mean(PCA_data.X(3,PCA_data.y == 2));

    mOthers = [mean_TSothersF1;mean_TSothersF2;mean_TSothersF3]; %m1
    mStop = [mean_TSStopF1;mean_TSStopF2;mean_TSStopF3];         %m2

    disp('Doing Test Dataset Classification...');

    for j=1:length(Testing_HOG)
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

    % 1 - TS Others Class | 2 - TS Stop Class
    for i=1:size(TestingPCA.X,2)
        Euclidean_Results.Results(i) = Euclideandx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)]);
    end

    Euclidean_Results.Class = TestingPCA.y;

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

    % % % % % % % % % % % % % % % % % % % % % % 
    % Mahalanobis minimum distance classifier %
    % % % % % % % % % % % % % % % % % % % % % % 


    C = cov(PCA_data.X'); %Covariance Matrix.

    for i=1:size(TestingPCA.X,2)
        Mahalanobis_Results.Results(i) = Mahalanobisx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],C);
    end

    Mahalanobis_Results.Class = TestingPCA.y;
    % Sensitivity and Specificity:
    disp('Calculating Mahalanobis Sensitivity and Specificity');
    [Mahalanobis_A_Sensitivity,Mahalanobis_A_Specificity] = Sensitivity_Specificity(Mahalanobis_Results);
    disp("Mahalanobis Sensitivity: " + Mahalanobis_A_Sensitivity + " | Mahalanobis Specificity: " +Mahalanobis_A_Specificity);

    % Drawing line 
%     aux = -0.5 * mOthers'* C * mOthers;
%     aux2 = -0.5 * mStop'* C * mStop;
%     b = aux - aux2;
%     w = [mOthers(1)-mStop(1) mOthers(2)-mStop(2) mOthers(3)-mStop(3)]*C;
%     figure;title('Mahalanobis'); ppatterns(PCA_data); pline(w,b);


    % % % % % % % % % % % % % % % % % % % % % % 
    %        FISHER Linear Discriminant       %
    % % % % % % % % % % % % % % % % % % % % % % 

    disp('Fisher Linear Discriminant...');
    model2 = fld(PCA_data);
    ypred = linclass(PCA_data.X,model2);
%     figure;title('Linear Fishers');ppatterns(PCA_data); pline(model2);
%     cerror(ypred,PCA_data.y);

    for i=1:size(TestingPCA.X,2)
        Fisher_Results.Results(i) = FisherClassify(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],model2.W');
    end

    Fisher_Results.Class = TestingPCA.y;
    % Sensitivity and Specificity:
    disp('Calculating Mahalanobis Sensitivity and Specificity');
    [Fisher_A_Sensitivity,Fisher_A_Specificity] = Sensitivity_Specificity(Fisher_Results);
    disp("Fisher Sensitivity: " + Fisher_A_Sensitivity + " | Fisher Specificity: " +Fisher_A_Specificity);

    % Getting best Linear Classifer
    disp('Best Linear Classifier for this Class...');
    maximum = max([Euclidean_A_Sensitivity,Mahalanobis_A_Sensitivity,Fisher_A_Sensitivity]);
    pos = find([Euclidean_A_Sensitivity,Mahalanobis_A_Sensitivity,Fisher_A_Sensitivity] == maximum);
    disp('1 - Euclidean | 2- Mahalanobis | 3- Fishers');
    if(length(pos) > 1)
        aux = [];
        for a=1:length(pos)
            if(pos(a) == 1)
                aux = [aux Euclidean_A_Specificity];
            elseif(pos(a) == 2) 
                aux = [aux Mahalanobis_A_Specificity];
            else
                aux = [aux Fisher_A_Specificity];
            end
        end
        maximum = max(aux);
        pos = find(aux == maximum);
    end
    
    disp(strcat('Best Linear is : ',int2str(pos)));
    
    out.SelectedFeatures = SelectedFeaturesPositions;
    out.HeroMean = mStop;
    out.OthersMean = mOthers;
    out.Covarience = C;
    out.FishersWeights = model2.W';
    out.SelectedClassifier = pos;
    out.PCA_model = PCA_model;
    
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

