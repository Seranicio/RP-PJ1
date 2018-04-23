% Rascunho

% Reading Hog Dataset

% Getting All Folders
% This one will take a really long time.
% if(exist('TSDATA_HOG_01','var') == 0)
%     TSFolder = GetFolders('Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_01/');
%     TSDATA_HOG_01 = ReadAllData(TSFolder);
%     TSFolder = GetFolders('Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_02/');
%     TSDATA_HOG_02 = ReadAllData(TSFolder);
%     TSFolder = GetFolders('Dataset/GTSRB_Final_Training_HOG/GTSRB/Final_Training/HOG/HOG_03/');
%     TSDATA_HOG_03 = ReadAllData(TSFolder);
%     TSFolder = GetFolders('Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
%     TSFolder.Path = TSFolder.Path(1);
%     TSFolder.folder = TSFolder.folder(1);
%     TSDATATesting_HOG_01 = ReadAllData(TSFolder);
%     TSFolder = GetFolders('Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
%     TSFolder.Path = TSFolder.Path(2);
%     TSFolder.folder = TSFolder.folder(2);
%     TSDATATesting_HOG_02 = ReadAllData(TSFolder);
%     TSFolder = GetFolders('Dataset/GTSRB_Final_Test_HOG/GTSRB/Final_Test/HOG/');
%     TSFolder.Path = TSFolder.Path(3);
%     TSFolder.folder = TSFolder.folder(3);
%     TSDATATesting_HOG_03 = ReadAllData(TSFolder);
%     TSDATATestingClass=xlsread('Dataset/GT-final_test_Class_Info.csv');
% end

% -------------------------------------

% If we have file .mat already saved:
[PCA_data,kruskal_data,SelectedFeaturesPositions] = ScenaryA('TSDATA_HOG_03');
Testing_HOG = load('HOG_DATA2','TSDATATesting_HOG_03');
Testing_HOG = struct2cell(Testing_HOG);
Testing_HOG = Testing_HOG{1};
load('HOG_DATA2','TSDATATestingClass');

% -------------------------------------

% Classifiers:

% % % % % % % % % % % % % % % % % % % % % 
% Euclidean minimum distance classifier %
% % % % % % % % % % % % % % % % % % % % % 

% Dimensionality = 3;
% x = [feature1;feature2;feature3];
% Classes -> 2 -> Traffic Stop Sign and Others.

disp('Calculating means for Classification...');
mean_TSothersF1 = mean([PCA_data.X(1,1:2940) PCA_data.X(1,3151:end)]);
mean_TSothersF2 = mean([PCA_data.X(2,1:2940) PCA_data.X(2,3151:end)]);
mean_TSothersF3 = mean([PCA_data.X(3,1:2940) PCA_data.X(3,3151:end)]);
mean_TSStopF1 = mean(PCA_data.X(1,2941:3150));
mean_TSStopF2 = mean(PCA_data.X(2,2941:3150));
mean_TSStopF3 = mean(PCA_data.X(3,2941:3150));

mOthers = [mean_TSothersF1;mean_TSothersF2;mean_TSothersF3]; %m1
mStop = [mean_TSStopF1;mean_TSStopF2;mean_TSStopF3];         %m2

disp('Doing Test Dataset Classification...');

for j=1:length(Testing_HOG)
    for i=1:length(SelectedFeaturesPositions)
        TestingPCA.X(i,j) =  Testing_HOG{j}(SelectedFeaturesPositions(i));
    end
    if(TSDATATestingClass(j,7) == 14)
        TestingPCA.y(j) = 2;
    else
        TestingPCA.y(j) = 1;
    end
end

TestingPCA.dim = length(SelectedFeaturesPositions);
TestingPCA.num_data = length(Testing_HOG);

model = pca(TestingPCA.X,3);
TestingPCA = linproj(TestingPCA,model);

% 1 - TS Others Class | 2 - TS Stop Class
for i=1:length(TestingPCA.X)
    Euclidean_Results.Results(i) = Euclideandx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)]);
end

Euclidean_Results.Class = TestingPCA.y;

clear i j;
% Sensitivity and Specificity:
disp('Calculating Euclidean Sensitivity and Specificity');
[Euclidean_A_Sensitivity,Euclidean_A_Specificity] = Sensitivity_Specificity(Euclidean_Results);
disp("Euclidean Sensitivity: " + Euclidean_A_Sensitivity + " | Euclidean Specificity: " +Euclidean_A_Specificity);
aux = -0.5 * (mOthers' * mOthers);
aux2 = -0.5 * (mStop' * mStop);
b = aux - aux2;
w = [mOthers(1)-mStop(1) mOthers(2)-mStop(2) mOthers(3)-mStop(3)];
figure; ppatterns(PCA_data); pline(w,b);

% % % % % % % % % % % % % % % % % % % % % % 
% Mahalanobis minimum distance classifier %
% % % % % % % % % % % % % % % % % % % % % % 

C = cov(PCA_data.X'); %Covariance Matrix.

for i=1:length(TestingPCA.X)
    Mahalanobis_Results.Results(i) = Mahalanobisx1_x2(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],C);
end

Mahalanobis_Results.Class = TestingPCA.y;
% Sensitivity and Specificity:
disp('Calculating Mahalanobis Sensitivity and Specificity');
[Mahalanobis_A_Sensitivity,Mahalanobis_A_Specificity] = Sensitivity_Specificity(Mahalanobis_Results);
disp("Mahalanobis Sensitivity: " + Mahalanobis_A_Sensitivity + " | Mahalanobis Specificity: " +Mahalanobis_A_Specificity);
aux = -0.5 * mOthers'* C * mOthers;
aux2 = -0.5 * mStop'* C * mStop;
b = aux - aux2;
w = [mOthers(1)-mStop(1) mOthers(2)-mStop(2) mOthers(3)-mStop(3)]*C;
figure; ppatterns(PCA_data); pline(w,b);

% % % % % % % % % % % % % % % % % % % % % % 
%        FISHER Linear Discriminant       %
% % % % % % % % % % % % % % % % % % % % % % 

disp('Fisher Linear Discriminant...');
model2 = fld(PCA_data);
ypred = linclass(PCA_data.X,model2);
figure; ppatterns(PCA_data); pline(model2);
cerror(ypred,PCA_data.y);

for i=1:length(TestingPCA.X)
    Fisher_Results.Results(i) = FisherClassify(mOthers,mStop,[TestingPCA.X(1,i);TestingPCA.X(2,i);TestingPCA.X(3,i)],model2.W');
end

Fisher_Results.Class = TestingPCA.y;
% Sensitivity and Specificity:
disp('Calculating Mahalanobis Sensitivity and Specificity');
[Fisher_A_Sensitivity,Fisher_A_Specificity] = Sensitivity_Specificity(Fisher_Results);
disp("Fisher Sensitivity: " + Fisher_A_Sensitivity + " | Fisher Specificity: " +Fisher_A_Specificity);

fileID = fopen('Log.txt','a+');
fprintf(fileID,"E:\n%d\n%d\nMahal:\n%d\n%dFisher:\n%d\n%d",Euclidean_A_Sensitivity,Euclidean_A_Specificity,Mahalanobis_A_Sensitivity,Mahalanobis_A_Specificity,Fisher_A_Sensitivity,Fisher_A_Specificity);
fclose(fileID);

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
