%%
clear all; close all; clc; workspace; fontsize = 12;

%% load setup parameter
load rho_values.mat;


%% load images from experiment
% Save the originial files in a seperate folder
% copyfile('*.bmp','Original');
% copyfile('*_raw.bmp','Raw');
% copyfile('*_color.bmp','Color'); 
% delete('*.bmp');
%% Read image sequence from the current directory
imagefiles = dir('*_raw.bmp'); % read the specified images in the current directory
fileNames = {imagefiles.name}'; % read the filename in a variable
numFrames = numel(fileNames); % count the number of images

%Iref = imread('background.bmp');
threshold = 20;
hsize = [9 9];
sigma = 0.5;

for p = 1:numFrames
    Im_Raw(:,:,p) = imread(fileNames{p});
    %myImage = myImagewnoise(:,:,1) - Iref;
    Im_Gauss(:,:,p) = imgaussfilt(Im_Raw(:,:,p),sigma,'FilterSize',hsize);
    Im_Thresh = Im_Gauss(:,:,p);
    Im_Thresh(Im_Thresh<threshold)=0;
    %imshow(Im_Thresh,[]);  title(sprintf('Processed Image # %d',p));pause(1);
    sumpix(p)=sum(sum(Im_Thresh));
 end
imagedatafilt = Im_Thresh;


%% A single image scatter plot with figures

figure('Units', 'pixels','Position', [100 100 1000 700]);hold on;
subplot(2,2,1);
title('(a) 480x480 pixel image');axis([0 481 0 481]); hold on
image(imagedatafilt);
%image(imagedata);

imagedatamod = double(imagedatafilt(:));
fluence = log((rho.^2).*imagedatamod);

subplot(2,2,2)
scatter(rho,imagedatamod)
title('(b) Pixel intensity vs. Source-Detector distance')
xlabel ('Source-Detector distance abs(r) cm','FontSize', fontsize); 
ylabel('Pixel intensity  I(r)','FontSize', fontsize); hold on

subplot(2,2,3)
scatter(rho, fluence);
title('(c) Logarithm of r^2I(r) vs. Source-Detector distance')
xlabel ('Source-Detector distance abs(r) cm','FontSize', fontsize); 
ylabel('ln(r^2I(r))','FontSize', fontsize); hold on


% select roi comparing two graphs
%thresh = 40;
%roidistance=find(imagedatamod<thresh);
roidistance = find(rho>1.76);
rhomod = rho;
rhomod(roidistance)=[];
fluencemod = fluence;
fluencemod(roidistance)=[];



subplot(2,2,4)
scatter(rhomod,fluencemod)
title('(d) Logarithm of r^2I(r) vs. Source-Detector distance in region of interest')
xlabel ('Source-Detector distance abs(r) cm','FontSize', fontsize); 
ylabel('ln(r^2I(r))','FontSize', fontsize);
%% Multiple images scatterplot
distthreshold = 1.76;

for i = 1:2
xs = xseries(i);
imagedata = tsdata.Data(:,:,i);%extract imagedata from timeseries variable
[mueff,muaexpt,muerror] = mucalculator(nd, p, xs, ys, zs, background, imagedata, dist, muaref, musref);
fprintf('Position:%d mueff=%4.4f mua=%4.4f Error=%4.4f\n',i,mueff,muaexpt,muerror)
muaexptmod(i)=muaexpt;
end


%muerror = 100*(abs(muaexpt-muaref))/muaref;
fprintf('\n mueff   mua \n');
fprintf('%4.4f %4.4f \n',mueff,muaexpt)
