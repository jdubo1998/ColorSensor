global numColors;
global Vals;
global ValsX;
global cSens;
global colors;
global C;
global numCentroids;
% colors: array that contain color names as a string.
colors = {"Blue", "Blue", "Red", "Red", "Del", "Del", "Del", "Del", "Del", "White", "White", "HDPE", "STEEL", "STEEL", "STEEL", "None", "Del"};
% cols: array that contains char[] of color abreviations.
cols = {'B', 'b', 'R', 'r', 'DaG', 'LiG', 'g', 'Y', 'y', 'W', 'w', 'p', 'DaM', 'LiM', 'm', 'NaC', 'Del'};

numReads = 300; % Indicates the number of times the color sensor will gather readings.
numCentroids = 1;e1

numColors = length(cols) - 1;

if contains(input('Change Any Color: ', 's'), 't')
    for i = 1:numColors
		% Gets user input for reading the color of each colored marble, t = true and f = false.
		% If true, the sensor will gather 300 RGB readings of the marble color.
		% If false, the sensor will skip that color.
        if contains(input(['Change ', cols{i}, ': '], 's'), 't')
			% Iterates 300 times.
            for j = 1:numReads
                Vals{j, i} = cSens.readColorRGB; % Reads in color from sensor.
                fprintf("Read " + num2str(j) + ": " + num2str(Vals{j,i}) + "\n");
            end

            turnMot(cMot);
        end
    end
end

% Sets the values of the RGB into an x, y, z coordinate on a graph.
for i = 1:numColors
    for j = 1:numReads
        ValsX{i}(j,1) = Vals{j, i}(1);
        ValsX{i}(j,2) = Vals{j, i}(2);
        ValsX{i}(j,3) = Vals{j, i}(3);
    end
end

% Uses a k-means algorythm to find the centeroid of each color cluster on the graph.
for i = 1:numColors
    [idx,C{i}] = kmeans(ValsX{i}, numCentroids);
end