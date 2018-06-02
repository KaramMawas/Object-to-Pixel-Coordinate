% Karam Mawas  M.No:2946939
close all
clear all
clc

data = dlmread('Signalized_Points_R0020851.txt','\t');
label = cellstr(num2str(data(:,1)));

c = 21.6335; % focal length [mm]
delta_pix = 0.0055; % the pixel size [mm]
mx = 1/delta_pix;
px = 2143.5; % principal point in x-direction [pixel]
py = -1423.5; % principal point in y-direction [pixel]
px_m = px/mx; % principal point in x-direction [M]
py_m = py/mx; % principal point in y-direction [M]


num = data(:,1); % the points number
X = data(:,2:4); % the points coordinates
X = [X ones(7,1)]; % the homogeneous coordinates of the points
X = X';

% the camera matrix
K = [-3933.363636 0       2143.5
     0        3933.363636 1423.5
     0            0            1];
% K = [mx 0 0; 0 mx 0; 0 0 1]*[-c 0 px_m; 0 c py_m; 0 0 1]; % [-c] to flip
% the y-axis to be consist with the matlab coordinate system

% the rotation matrix
R = [-0.82757075  -0.557530412  0.065471324
      0.549857636 -0.82856977  -0.10549273
      0.113062965 -0.05130279   0.99226246];

% the translation vector (X~0)
t = [512980.9951 5427701.527 514.79429];


t = t';
% the exterior orientation matrix of the camera
R_t = [R -R*t];

% the projection matrix
P = K*R_t; 

% the image coord.
x = P*X;
% normalizing the coord. to be homogen.
x_x = x(1,:)./x(3,:);
x_y = x(2,:)./x(3,:);
x_z = x(3,:)./x(3,:);


f = figure; 

im = imread('R0020851.jpg');
% im = imresize(im,0.17);
im = imshow(im);
hold on
plot (x_x,x_y,'r+','MarkerSize',12);
text(x_x,x_y,label, 'VerticalAlignment','bottom','HorizontalAlignment','right','color','g');
title('Projecting points on Image')
saveas(f,sprintf('Points_image%d.png',0));

