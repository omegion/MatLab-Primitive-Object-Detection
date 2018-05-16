% Hakan Kurtulus
% HXMKGP

clear all; close all; clc; % clear defined variable from previous run

im = imread('objects.jpg'); %circles are greater than rectangles
%im = imread('objects_1.jpg'); %circles and rectangles are equal 

[h, w, ~] = size(im); %get height and width of image

distR = double(im(:, :, 1)) - 0; %since we have only one dimention, first dimention of image will be enough

%L2 distance
d2 = (distR .^2); %highlited to background, at the end we will have so big number for background but white parts will be close to 0

thres = 13000;
results = d2 <= thres; %we set the boundary for image not to detect image itself but objects

results = bwmorph(results, 'erode', 1);
results = bwmorph(results, 'open', 2);
results = bwmorph(results, 'close', 2);


stats = regionprops(results, 'BoundingBox'); %this gets the stats of each object, we used this with Gabor

figure, imshow(results);
hold on

circle_num = 0;
rec_num = 0;
for i = 1 : length(stats)

    dimentions = stats(i).BoundingBox;
    
    YourText = sprintf(int2str(i)); %put the iteration numbe rto variable to print as string
    
    if dimentions(3)== dimentions(4) %3 and 4 stand for height and width of object, if the values are equal it is circle ortherwise ellipse
        circle_num = circle_num+1;
        hText = text(dimentions(1) + dimentions(3)/2,dimentions(2)+dimentions(4)/2,YourText,'Color',[1 0 1],'FontSize',15); %put the pink string to image
    elseif dimentions(3)~= dimentions(4)
        rec_num = rec_num+1;
        hText = text(dimentions(1) + dimentions(3)/2,dimentions(2)+dimentions(4)/2,YourText,'Color',[0.1 0 0.5],'FontSize',15); %put the blue string to image
    end
    
    rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 3); %draw a rectangle also we used this with Gabor
    
end

h = [int2str(circle_num) ' Circle is found']
k = [int2str(rec_num) ' Rectangle is found']

if circle_num == rec_num
    final = 'Circle and Rectangle numbers are equal.'
elseif circle_num < rec_num
    final = 'Rectangle numbers are greater than circle numbers.'
elseif circle_num > rec_num
    final = 'Circle numbers are greater than rectangler numbers.'
end
    