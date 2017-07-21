function blobs = detectBlobsScaleImage(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSCALEIMAGE(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the image and keeps the
%   filter same for speed. 
% 
% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% This code is taken from:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector

im = rgb2gray(im);
im = im2double(im);
dims = size(im);
kernel = fspecial('log', [3, 3], .3 * 3);
fun = @NMS;
im2 = im;
blobcount = 1;
secondSpace = zeros(dims(1), dims(2), 15);
ongS = dims(1);
index = 1;
scale = .3 * 3;

scale = scale * 10/6;
scale = scale * 10/6;
im2 = imresize(im2, 6/10);
im2 = imresize(im2, 6/10);
tempS = size(im2);
ongS = tempS(1);

while ongS > 20
    secondSpace(:, :, index) = imresize(imfilter(im2, kernel), [dims(1) dims(2)]);
    
    %nms on each 2d slide
    secondSpace(:,:,index) = nlfilter(secondSpace(:,:,index), [floor(scale), floor(scale)], fun);
    
    %add blobs
    array = find(secondSpace(:,:,index));
    sizeA = size(array);
    for integer = 1:sizeA(1)
         x = rem(array(integer), dims(1));
         y = floor(array(integer) / dims(1)) + 1;
         if(x == 0)
             x = dims(1);
         end;
         blobs(blobcount, :) = [y, x, scale, secondSpace(x, y, index)];
         blobcount = blobcount + 1;
    end
    
%update
    im2 = imresize(im2, 8/10);
    scale = scale * 10/8;
    tempS = size(im2);
    ongS = tempS(1);
    index = index + 1;
end

blobs = sortrows(blobs, 4);
blobs = flipud(blobs);
blobs = blobs(1:1000, :);


function padded = NMS(temp)
     dim = size(temp);
     snake = temp(:);
     pos = ceil(dim(1) * dim(1) * .5);
     
     %add threshold here
     if(snake(pos) == max(snake) && snake(pos) > .01) ;
         padded = snake(pos);
     else
         padded = 0;
     end
