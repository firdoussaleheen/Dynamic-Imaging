%% TIS Image Processing Program
% Software Name: image_proc_tis_v1.m
% Firdous Saleheen
% 08/14/2014
 
%% Clear workspace and close all figures
clear all;% close all; clc;

%% Save the originial files in a seperate folder
% copyfile('*.bmp','Original');
% copyfile('*_raw.bmp','Raw');
% copyfile('*_color.bmp','Color'); 
% delete('*.bmp');
%% Read image sequence from the current directory
imagefiles = dir('*_raw.bmp'); % read the specified images in the current directory
fileNames = {imagefiles.name}'; % read the filename in a variable
numFrames = numel(fileNames); % count the number of images

%Iref = imread('background.bmp');
threshold = 30;

hsize = [9 9];
sigma = 3;
H = fspecial('gaussian',hsize,sigma);

for p = 1:numFrames
    Im_Raw(:,:,p) = imread(fileNames{p});
    %myImage = myImagewnoise(:,:,1) - Iref;
    Im_Gauss(:,:,p) = imfilter(Im_Raw(:,:,p),H,'replicate');
    Im_Thresh = Im_Gauss(:,:,p);
    Im_Thresh(Im_Thresh<threshold)=0;
    %imshow(Im_Thresh,[]);  title(sprintf('Processed Image # %d',p));pause(1);
    sumpix(p)=sum(sum(Im_Thresh));
 end
sumpix_tiss=sumpix'

%% Plot intensity versus x-axis Position
x = 28:4:76;
figure;
%plot(x',sumpix_tut,'r','Marker','o','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
plot(x',sumpix_tutt,'b','Marker','s','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
plot(x',sumpix_tiss,'g','Marker','>','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
xlabel('Horizontal Position (mm)','FontSize',14);
ylabel('Integrated Pixel Intensity (pixel)','FontSize',14);
legend('Tumor','Tissue')
%axis([xmin xmax ymin ymax])
axis([28 76 0.5e6 5.9e6])
grid on;

%% Plot absorption coefficient and tis size estimation on same plot for 635nm
x = 28:4:76; % x axis
mua = [0.0721 0.0813 0.0912 0.0982 0.1155 0.1299 0.1312 0.1315 0.1321 0.1115 0.0925 0.089 0.065]; % absorption coefficient from DOT 


xCenter = 52;
zCenter = 28+6;
theta = 0 : 0.01 : 2*pi;
radius = 11.04/2;
xcircle = radius * cos(theta) + xCenter;
zcircle = radius * sin(theta) + zCenter;
%plot(xcircle, zcircle);
%axis square;
% xlim([28 76]);
% ylim([28 76]);

[ax,p1,p2]=plotyy(x',mua,xcircle,zcircle);

% p1.LineStyle = '-';
% p1.LineWidth = 2.5;
% p1.Marker = 's';
% p1.MarkerSize = 10;
% 
% p2.LineStyle = '-';
% p2.LineWidth = 2.5;
% p2.Marker = 'o';
% p2.MarkerSize = 10;


%grid on;

ylabel(ax(1),'Absorption Coefficient (/cm)','FontSize',14) % label left y-axis
ylabel(ax(2),'Vertical Position z (mm)','FontSize',14) % label right y-axis
xlabel(ax(2),'Horizontal Position x (mm)','FontSize',14') % label x-axis



figure;
%plot(x',sumpix_tut,'r','Marker','o','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
plot(x',mua,'b','Marker','s','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
%plot(x',sumpix_tiss,'g','Marker','>','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
xlabel('Horizontal Position (mm)','FontSize',14);
ylabel('Absorption Coefficient (/cm)','FontSize',14);
% legend('Tumor','Tissue')
% %axis([xmin xmax ymin ymax])
% axis([28 76 0.5e6 5.9e6])
grid on;

%%
figure;
xangle = [36 48 54 60 72]; % x axis
mua = [0.0330 0.0702 0.0908 0.0794 0.0189]; % absorption coefficient from DOT 
plot(xangle,mua,'r','Marker','>','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
xlabel('Horizontal Position (mm)','FontSize',14);
ylabel('Absorption Coefficient (/cm)','FontSize',14);
grid on;


%%
%% Plot absorption coefficient and tis size estimation on same plot for 808nm
x = 28:4:76; % x axis
mua = [0.2899 0.2899 0.3419 0.3920 0.3831 0.3859 0.4019 0.6399 0.4443 0.3832 0.3780 0.3220 0.2698]; % absorption coefficient from DOT
figure;
plot(x,mua,'r','Marker','>','MarkerSize', 10, 'LineWidth',2.5,'LineStyle','-');hold on;
xlabel('Horizontal Position (mm)','FontSize',14);
ylabel('Absorption Coefficient (/cm)','FontSize',14);
grid on;

%% assuming live tissue
% lambda CHbO2   CHb
% 634	512.4	4730.8
% 636	478.8	4602.4
% 808	856	723.52

epsilon_CHbO2_635 = 495.6;
epsilon_CHb_635 = 4666;
epsilon_CHbO2_808 = 856;
epsilon_CHb_808 = 723.52;

epsilon_matrix = [epsilon_CHbO2_635 epsilon_CHb_635;epsilon_CHbO2_808 epsilon_CHb_808];
epsilon_matrix_inv = inv(epsilon_matrix);

mu_a_tumor = [0.1312 0.4680];
mu_a_tissue = [0.0907 0.3389];

C_tumor = epsilon_matrix_inv*mu_a_tumor'
C_tissue = epsilon_matrix_inv*mu_a_tissue'


