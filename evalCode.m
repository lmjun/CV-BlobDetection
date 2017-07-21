% Evaluation code for blob detector
%
% Your goal is to implement the laplacian of the gaussian blob detector 
%
%
% This code is taken from:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector

imageName = 'butterfly.jpg'; %butterfly.jpg, einstein.jpg, fishes.jpg, sunflowers.jpg

dataDir = fullfile('C:\Users\lmjun\Desktop\hw3','data');
im = imread(fullfile(dataDir, imageName));

%% Implement the code to detect blobs here
% First implement a version that scales the filter and applies on the
% image
tic;
blobs1 = detectBlobsScaleFilter(im);
toc;

% Now implement a version that scales the image
tic;
blobs2 = detectBlobsScaleImage(im);
toc;

%% Draw blobs on the image
numBlobsToDraw = 1000;
drawBlobs(im, blobs1, numBlobsToDraw);
title('Blob detection: scale filter');

drawBlobs(im, blobs2, numBlobsToDraw);
title('Blob detection: scale image');
