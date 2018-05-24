function classification_results = KNNClassifier(PCA_data,TestingPCA,k)
    distance_results = zeros(1,length(PCA_data.X));
    classification_results = zeros(1,length(TestingPCA.X));
    % Hand Euclidean distance
    disp('Calculating Euclidean Distance for all Testing Dataset and K-NN...');
    for i=1:length(TestingPCA.X)
        if(rem(i,1000) == 1)
            fprintf("%d / %d points processed\n",i-1,length(TestingPCA.X));
        end
        % Compute Distance between point we analysing and all others in
        % clusters.
        for j=1:length(PCA_data.X)
            distance_results(j) = norm([TestingPCA.X(:,i)]' - [PCA_data.X(:,j)]');
        end
        %Classification with k most proximity points.
        minvalues = mink(distance_results,k); %Gets most k proximity points distance
        %Gets cluster points class.
        Classes_near_point = zeros(1,length(minvalues));
        for j=1:length(minvalues)
            minpos = distance_results == minvalues(j); 
            Classes_near_point(j) = PCA_data.y(minpos);
        end
        %Compute class for point.
        [occurences,class] = hist(Classes_near_point,unique(Classes_near_point));
        % if we have 2 or more same number of classes with same occurences
        % decide based on min distance point (ITS MY CHOICE , u can do
        % mean for example).
        aux2 = find(occurences == max(occurences));
        classification_results(i) = class(aux2(1));
    end
end

