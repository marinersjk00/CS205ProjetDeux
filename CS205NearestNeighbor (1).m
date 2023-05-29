function maxAcc = jkProject2()
    %global data;
    data = load("/MATLAB Drive/datasets/Pistachio_16_Features_Dataset_Processed.txt");
    fprintf("Welcome to Jordan Kuschner and Liam Bui's Feature Selector\n\n");

    %mins = min(data, [], 1);
    %fprintf('%g ', mins);
    

    %maxs = max(data, [], 1 );
    %fprintf('%g ', maxs);


    data(:, 2:size(data, 2)) = normalize(data(:, 2:size(data, 2)));
    fprintf('%0.3f', data(1, 1));


    %normalized_data(mins, maxs);
    %fprintf('%g\n', data);

    x = input("Please enter 1 for forward selection or 2 for backwards elimination");

    

    maxAcc = 0;
    featureSet = [];

    tic
    if x == 2
        fprintf("Beginning backward search...");
        feature_search_backwards(data);
    end
    if x == 1
        fprintf("Beginning forward search...");
        feature_search_forwards(data);
    end
    time = toc
    disp(featureSet);
    minutes = 0;
    if time > 60
        time = time / 60;
        minutes = 1;
    end

    if minutes == 0
        fprintf("Elapsed Time: %0.3f seconds", time);
    end

    if minutes == 1
        fprintf("Elapsed Time: %0.3f minutes", time);
    end

    fprintf("\nAccuracy = %0.4f", maxAcc);
    function currentSet = feature_search_forwards(data)
    
    
    currentSet = [];
        for i = 1 : size(data,2)-1
            disp(["On the ", int2str(i), "th level of the search tree"]);
            featureToAdd = [];
            bestAccSoFar = 0;
          
            for k = 1 : size(data, 2)-1
                 if isempty(intersect(currentSet, k))
                     disp(["-->Considering adding ", int2str(k), "th feature..."]);
                 
                     accuracy = leaveOneOut(data, currentSet, k) 
        
                    if accuracy > bestAccSoFar
                        bestAccSoFar = accuracy;
                        featureToAdd = k;
                      
                    end
                    
                
                end
            end

            currentSet(i) = featureToAdd;
            disp(["On level ", num2str(i), " I added feature ", num2str(featureToAdd), " from the set." ])
            disp(currentSet)
            if bestAccSoFar > maxAcc
                            maxAcc = bestAccSoFar;
                            % featureSet = [];
                            featureSet = currentSet;
                            %ind = ind + 1;
            end
           
        end
    end

 function currentSet = feature_search_backwards(data)
    currentSet = [];
    for q = 1 : size(data,2)-1
        currentSet(q) = q;
    end
    
        for i = 1 : size(data,2)-1
            disp(["On the ", int2str(i), "th level of the search tree"]);
            featureToRemove = [];
            bestAccSoFar = 0;
          
            for k = 1 : size(data, 2)-1
                if ~isempty(intersect(currentSet, k))
                     disp(["-->Considering removing ", int2str(k), "th feature..."]);
                     
                     accuracy = removeElement(data, currentSet, k);
                     disp(accuracy);
        
                    if accuracy > bestAccSoFar
                        bestAccSoFar = accuracy;
                        featureToRemove = k;
                      
                    end
                end  
                
                
            end

            for z = 1 : length(currentSet)
                if currentSet(z) == featureToRemove
                    currentSet(z) = [];
                    break;
                end
            end
            disp(["On level ", num2str(i), " I removed feature ", num2str(featureToRemove), " from the set." ])
            disp(currentSet)
            if bestAccSoFar > maxAcc
                            maxAcc = bestAccSoFar;
                            featureSet = currentSet;
            end
           
        end
 end

    
    function accuracy = leaveOneOut(data, currentSet, featureToAdd)
    for i = 2 : size(data, 2)
        if isempty(intersect(currentSet, i-1)) && i-1 ~= featureToAdd
               data(:, i) = 0;
        end
    end
    numCorrect = 0;
    for i = 1 : size(data, 1)
        testObj = data(i, 2:end);
        testLabel = data(i, 1);
    
        nearestNeighborDist = inf;
        nearestNeighborLoc = inf;
    
        for k = 1 : size(data, 1)
            
            if k ~= i
                %disp(['Is ', int2str(i), ' a nearest neighbor with ', int2str(k), '?']);
                distance = sqrt(sum((testObj - data(k, 2:end)).^2));
                if distance < nearestNeighborDist
                    nearestNeighborDist = distance;
                    nearestNeighborLoc = k;
                    nearestNeighborLabel = data(nearestNeighborLoc, 1);
                end
            end
        end
    
        if testLabel == nearestNeighborLabel
            numCorrect = numCorrect + 1;
    
        end
    
    end
        accuracy = numCorrect / size(data, 1);
    end

    function accuracy = removeElement(data, currentSet, featureToRemove)
    for i = 2 : size(data, 2)
        if isempty(intersect(currentSet, i-1)) || (i-1) == featureToRemove
               data(:, i) = 0;
        end
    end
    numCorrect = 0;
    for i = 1 : size(data, 1)
        testObj = data(i, 2:end);
        testLabel = data(i, 1);
    
        nearestNeighborDist = inf;
        nearestNeighborLoc = inf;
    
        for k = 1 : size(data, 1)
            
            if k ~= i
                %disp(['Is ', int2str(i), ' a nearest neighbor with ', int2str(k), '?']);
                distance = sqrt(sum((testObj - data(k, 2:end)).^2));
                if distance < nearestNeighborDist
                    nearestNeighborDist = distance;
                    nearestNeighborLoc = k;
                    nearestNeighborLabel = data(nearestNeighborLoc, 1);
                end
            end
        end
    
        if testLabel == nearestNeighborLabel
            numCorrect = numCorrect + 1;
    
        end
    
    end
        accuracy = numCorrect / size(data, 1);
    end

    function data2 = normalized_data(mins, maxs)
    data2 = load("/MATLAB Drive/datasets/Pistachio_16_Features_Dataset_Processed.txt");
    for i = 2 : size(data2,2)-1
        column = data2(:, i);
        %fprintf('%d', size(column, 1)); %num of rows
        for k = 1 : size(column, 1)
            column(k) = (column(k) - mins(i))/(maxs(i) - min(i));
            %fprintf('%0.3f', column(k));
            %y = input("PAUSE");
            data2(i, k) = column(k);
            %fprintf('%0.3f', data2(i,k));
            %z = input("PAUSE");
        end
    end
    end
end