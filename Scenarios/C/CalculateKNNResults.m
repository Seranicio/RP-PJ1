function out = CalculateKNNResults(Results,TSDATATestingClass)
    TP = 0;
    TN = 0;

    if(isstruct(TSDATATestingClass))
        new = TSDATATestingClass.y;
    else
        new = TSDATATestingClass(:,7);
    end
    
    % We add to add 1 to all classes when training because i think to do
    % pca/lda you can't have class label '0'
    new = new(:) + 1;
    
    for i=1:length(Results)
        if(Results(i) == new(i))
            TP = TP + 1;
        else
            TN = TN + 1;
        end
    end
    
    disp(TP);
    disp(TN);
    disp('Sens:')
    disp(TP/(TP + TN));
    
    out = TP/(TP + TN);
%     save a ;
end

