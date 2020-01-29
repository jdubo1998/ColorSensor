% GETVALUES - Uses color sensor and pre-recorded color values, in order to determine color of an unknown marble.

function color = getValues(testing)
    global numColors;
    global colorAmount;
    global ValsX;
    global colors;
    global C;
    global numCentroids;
    global cSens;
    global cMot;
    
    color = "";
	graph = true;
    
    colorAmount = zeros(1, numColors);
    maxDistance = 1000;
    aReads = 150;
    distances = zeros(numCentroids, numColors);
    c = cell(1, aReads);

    numMarbles = zeros(1, length(colors));
    aColor = zeros(1, aReads);
	
	% Used for displaying the graphic represneation of the colors and centroids.
    if (graph)
        graphKClusters(numColors,ValsX,C);
        OptionZ.FramRate=30;OptionZ.Duration=8;OptionZ.Periodic=true;
    else
        for i = 1:aReads
			% Begins by getting the color of the unknown marble color.
            try
                c{i} = cSens.readColorRGB;
			% Exception thrown if the sensor is not detected by the program.
            catch
                fprintf('No Sensor Connected');
            end

            for j = 1:numColors
				% Gets the distance of the unknown marble RGB values and the RGB value of the centroid of the pre-recorded colors.
                distances(:,j) = double(sqrt( (c{i}(1)-C{j}(:,1)).^2 + (c{i}(2)-C{j}(:,2)).^2 + (c{i}(3)-C{j}(:,3)).^2 ));
            end
            
			% Gets the magnitude between the RGB values of the unknown color on the graph, and each of the color cluster centers.
			% the cluster with the shortest distance determines what color the unknown marble belongs to.
            if min(min(distances)) < maxDistance
                aColor(i) = find(min(min(distances)) == distances);
            else
                aColor(i) = length(colors);
            end
        end
        
        color = colors{ mode(aColor) };
        
        if color ~= "None" && color ~= "NaC"
            if testing
                turnMot(cMot);
            end
        end
    end
end

% Function used to graph the color clusters.
% A 3D video render is attached within this zip, (Graphic Display of Colors and Centroids.mp4)
% displaying the color clusters and the X is used to mark the centroid.
function graphKClusters(numColors,ValsX,C)
	% Formatting of the graph.
    hold on;
    zoom out;
	bg = .8;
    whitebg([bg, bg, bg]); % Neutral background color in graph.
    leg = zeros(1, numColors); % Adds a legen to the graph.

    for j = 1:8
        col = (C{j}*2)/255;
        col(col > 1) = 1;
        
		% Sets up 3D scatter plot for the color values.
		% Uses a 1 by 3 array to record each value of RGB into X Y and Z.
        scatter3(ValsX{j}(:,1), ValsX{j}(:,2), ValsX{j}(:,3), 3, col);
		
		% This maps out the center of each color cluster.
        scatter3(C{j}(:,1), C{j}(:,2), C{j}(:,3), 200, col, 'x', 'MarkerFaceColor', col);
    end

	% Labels axis for the graph.
    xlabel('Red');
    ylabel('Green');
    zlabel('blue');
    hold off;
end
