function out = CalculateKNNResults(Results,TSDATATestingClass,Info)
    TP = 0;
    TN = 0;

    if(isstruct(TSDATATestingClass))
        new = TSDATATestingClass.y;
    else
        new = TSDATATestingClass(:,7);
    end

    % This outputs a new array where each sign belong to each class
    for i=1:length(Info.ClassName)
        aux = Info.ClassIDs(Info.ClassIDs(:,i) ~= -1,i);
        for j=1:length(aux)
            new(new(:) == Info.ClassIDs(j,i)) = i;
        end
    end
    
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
end

