
function blobs = detectBlobsScaleFilter(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSSCALEFILTER(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the filter and keeps the
%   image same which is slow for big filters.
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
scale = 3;
sigma = .3 * scale;
fun = @NMS;
blobcount = 1;

scaleSpace = zeros(dims(1), dims(2), 8); %[h,w] - dimensions , n - levels in scale space
for index = 1:8
    kernel = fspecial('log', [scale, scale], sigma);
    scaleSpace(:,:,index) = sigma * sigma * imfilter(im, kernel);
    
    %nms on each 2d slide
    scaleSpace(:,:,index) = nlfilter(scaleSpace(:,:,index), [scale scale], fun);
    
    %nms on 3d slides
    if (index ~= 1)
        C = find(scaleSpace(:, :, index));
        sizeC = size(C);
        underneath = scaleSpace(:,:,index - 1);
        for integer = 1:sizeC(1)
            %find coord
            x = rem(C(integer), dims(1));
            y = floor(C(integer) / dims(1)) + 1;
            if(x == 0)
                x = dims(1);
            end;
            offset = floor(.3* scale);
            if(x - offset > 0 && x + offset < dims(1) + 1 && y - offset > 0 && y + offset < dims(2) + 1)
                conc = underneath([x - offset, x + offset], [y - offset, y + offset]);
                undermax = max(conc(:));
                if(undermax > scaleSpace(x, y, index))
                    scaleSpace(x, y, index) = 0;
                end
            end
        end
    end
    
    array = find(scaleSpace(:,:,index));
    sizeA = size(array);
    for integer = 1:sizeA(1)
         x = rem(array(integer), dims(1));
         y = floor(array(integer) / dims(1)) + 1;
         if(x == 0)
             x = dims(1);
         end;
         if(scaleSpace(x, y, index))
            blobs(blobcount, :) = [y, x, .3 * scale, scaleSpace(x, y, index)];
            blobcount = blobcount + 1;
         end
    end
    
    %update
    scale = (scale * 2) - 1;
    sigma = .3 * scale;
end

blobs = sortrows(blobs, 4);
blobs = flipud(blobs);
blobs = blobs(1:1000, :);

function padded = NMS(temp)
     dim = size(temp);
     snake = temp(:);
     pos = ceil(dim(1) * dim(1) * .5);
     
     %add threshold here
     if(snake(pos) == max(snake) && snake(pos) > .03);
         padded = snake(pos);
     else
         padded = 0;
     end