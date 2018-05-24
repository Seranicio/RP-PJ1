function LinearClassifiers(PCA_data,PCA_model,Testing_HOG,SelectedFeaturesPositions,TsBegging,TsEnd,ObjectID,Single)
    load('HOG_DATA','TSDATATestingClass');

    % Classifiers:

    % % % % % % % % % % % % % % % % % % % % % 
    % Euclidean minimum distance classifier %
    % % % % % % % % % % % % % % % % % % % % % 

    % Dimensionality = 3;
    % x = [feature1;feature2;feature3];
    % Classes -> 2 -> Traffic Stop Sign and Others.

    disp('Calculating means for Classification...');
    mean_TSothersF1 = mean([PCA_data.X(1,1:TsBegging-1) PCA_data.X(1,TsEnd-1:end)]);
    mean_TSothersF2 = mean([PCA_data.X(2,1:TsBegging-1) PCA_data.X(2,TsEnd-1:end)]);
    mean_TSothersF3 = mean([PCA_data.X(3,1:TsBegging-1) PCA_data.X(3,TsEnd-1:end)]);
    mean_TSStopF1 = mean(PCA_data.X(1,TsBegging:TsEnd));
    mean_TSStopF2 = mean(PCA_data.X(2,TsBegging:TsEnd));
    mean_TSStopF3 = mean(PCA_data.X(3,TsBegging:TsEnd));

    mOthers = [mean_TSothersF1;mean_TSothersF2;mean_TSothersF3]; %m1
    mStop = [mean_TSStopF1;mean_TSStopF2;mean_TSStopF3];         %m2

    disp('Doing Test Dataset Classification...');

    if(Single == 0)
        testingsize = size(Testing_HOG,2);
    else
        testingsize = size(Testing_HOG,1);
    end
    
    for j=1:testingsize
        for i=1:length(SelectedFeaturesPositions)
            TestingPCA.X(i,j) =  Testing_HOG{j}(SelectedFeaturesPositions(i));
        end
        if(Single == 0)
            if(TSDATATestingClass(j,7) == ObjectID)
                TestingPCA.y(j) = 2;
            else
                TestingPCA.y(j) = 1;
            end 
        else
            TestingPCA.y(j) = 0;
        end
    end

    TestingPCA.dim = length(SelectedFeaturesPositions);
    TestingPCA.num_data = length(Testing_HOG);

    TestingPCA = linproj(TestingPCA,PCA_model);

    % 1 - TS Others Class | 2 - TS Stop Class
    for i=1:size(TestingPCA.X,2)
        Euclidean_Results.Results(i) = Euclideandx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)]);
    end
    
    if(Single == 1)
        if(Euclidean_Results.Results(1) < 0)
            disp('Euclidean Says its a Stop Sign');
        else
            disp('Euclidean Says its a not Stop Sign');
        end
    end

    if(Single == 0)
        Euclidean_Results.Class = TestingPCA.y;

        clear i j;
        % Sensitivity and Specificity:
        disp('Calculating Euclidean Sensitivity and Specificity');
        [Euclidean_A_Sensitivity,Euclidean_A_Specificity] = Sensitivity_Specificity(Euclidean_Results);
        disp("Euclidean Sensitivity: " + Euclidean_A_Sensitivity + " | Euclidean Specificity: " +Euclidean_A_Specificity);
        % Drawing line 
        aux = -0.5 * (mOthers' * mOthers);
        aux2 = -0.5 * (mStop' * mStop);
        b = aux - aux2;
        w = [mOthers(1)-mStop(1) mOthers(2)-mStop(2) mOthers(3)-mStop(3)];
        figure;title('Euclidean');ppatterns(PCA_data); pline(w,b);
    end
    % % % % % % % % % % % % % % % % % % % % % % 
    % Mahalanobis minimum distance classifier %
    % % % % % % % % % % % % % % % % % % % % % % 

    C = cov(PCA_data.X'); %Covariance Matrix.

    for i=1:size(TestingPCA.X,2)
        Mahalanobis_Results.Results(i) = Mahalanobisx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],C);
    end
    
    if(Single == 1)
        if(Mahalanobis_Results.Results(1) < 0)
            disp('Mahalanobis Says its a Stop Sign');
        else
            disp('Mahalanobis Says its a not Stop Sign');
        end
    end
    
    if(Single == 0)
        Mahalanobis_Results.Class = TestingPCA.y;
        % Sensitivity and Specificity:
        disp('Calculating Mahalanobis Sensitivity and Specificity');
        [Mahalanobis_A_Sensitivity,Mahalanobis_A_Specificity] = Sensitivity_Specificity(Mahalanobis_Results);
        disp("Mahalanobis Sensitivity: " + Mahalanobis_A_Sensitivity + " | Mahalanobis Specificity: " +Mahalanobis_A_Specificity);
        % Drawing line 
        aux = -0.5 * mOthers'* C * mOthers;
        aux2 = -0.5 * mStop'* C * mStop;
        b = aux - aux2;
        w = [mOthers(1)-mStop(1) mOthers(2)-mStop(2) mOthers(3)-mStop(3)]*C;
        figure;title('Mahalanobis'); ppatterns(PCA_data); pline(w,b);
    end
    % % % % % % % % % % % % % % % % % % % % % % 
    %        FISHER Linear Discriminant       %
    % % % % % % % % % % % % % % % % % % % % % % 

    model2 = fld(PCA_data);
    ypred = linclass(PCA_data.X,model2);
    if(Single == 0)
        figure;title('Linear Fishers');ppatterns(PCA_data); pline(model2);
        cerror(ypred,PCA_data.y);
    end
    
    for i=1:size(TestingPCA.X,2)
        Fisher_Results.Results(i) = FisherClassify(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],model2.W');
    end
    
    if(Single == 1)
        if(Fisher_Results.Results(1) < 0)
            disp('Fisher Says its a Stop Sign');
        else
            disp('Fisher Says its a not Stop Sign');
        end
        return;
    end

    if(Single == 0)
        Fisher_Results.Class = TestingPCA.y;
        % Sensitivity and Specificity:
        disp('Calculating Mahalanobis Sensitivity and Specificity');
        [Fisher_A_Sensitivity,Fisher_A_Specificity] = Sensitivity_Specificity(Fisher_Results);
        disp("Fisher Sensitivity: " + Fisher_A_Sensitivity + " | Fisher Specificity: " +Fisher_A_Specificity);
    end
    % Log.txt
%     fileID = fopen('log.txt','a+');
%     fprintf(fileID,"\n\nHOG: %s \nClass: %d\nEuclidean -> Sensitivity: %g | Specificity: %g",HOGlog, ObjectID , Euclidean_A_Sensitivity , Euclidean_A_Specificity);
%     fprintf(fileID,"\nMahalanobis -> Sensitivity: %g | Specificity: %g", Mahalanobis_A_Sensitivity , Mahalanobis_A_Specificity);
%     fprintf(fileID,"\nFishers -> Sensitivity: %g | Specificity: %g", Fisher_A_Sensitivity , Fisher_A_Specificity);
%     fclose(fileID);
    
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

