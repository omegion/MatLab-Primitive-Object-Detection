clear all; close all; clc; %  clear console and close all windows

im = imread('objects.jpg'); % circles are greater than rectangles
% im = imread('objects_1.jpg'); % circles and rectangles are equal 

[h, w, ~] = size(im); % get height and width of the image

distR = double(im(:, :, 1)) - 0; % since we have only one dimension, first dimension of image will be enough

% L2 distance
d2 = (distR .^2); % highlighted to background, at the end we will have so big number for background but white parts will be close to 0

thres = 13000;
results = d2 <= thres; % we set the boundary for image not to detect image itself but objects

results = bwmorph(results, 'erode', 1);
results = bwmorph(results, 'open', 2);
results = bwmorph(results, 'close', 2);


stats = regionprops(results, 'BoundingBox'); % this gets the stats of each object

figure, imshow(results);
hold on

circle_num = 0;
rec_num = 0;
for i = 1 : length(stats)
    dimensions = stats(i).BoundingBox;
    text = sprintf(int2str(i)); % put the iteration number to variable to print as string
    
    if dimensions(3) == dimensions(4) % 3 and 4 stand for height and width of object, if the values are equal it is circle otherwise ellipse
        circle_num = circle_num+1;
        hText = text(dimensions(1) + dimensions(3)/2,dimensions(2)+dimensions(4)/2,text,'Color',[1 0 1],'FontSize',15); % put the pink string to image
    elseif dimensions(3) ~= dimensions(4)
        rec_num = rec_num+1;
        hText = text(dimensions(1) + dimensions(3)/2,dimensions(2)+dimensions(4)/2,text,'Color',[0.1 0 0.5],'FontSize',15); % put the blue string to image
    end
    
    rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 3); % draw a rectangle
    
end

h = [int2str(circle_num) ' Circle is found']
k = [int2str(rec_num) ' Rectangle is found']

if circle_num == rec_num
    final = 'Circle and Rectangle numbers are equal.'
elseif circle_num < rec_num
    final = 'Rectangle numbers are greater than circle numbers.'
elseif circle_num > rec_num
    final = 'Circle numbers are greater than rectangle numbers.'
end
    