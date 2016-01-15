%% generate meshgrid for the point source and detector array position
n_pixel = 480; % pixel captured by 768x492 ccd camera
l_sample = 23; % mm
p = l_sample/n_pixel; % mm/pixel pixel-mm conversion factor
nd = 480; % number of detector in array
ns = 1; %number of source
[xd,yd,zd]=meshgrid(0:1:nd-1,0:1:nd-1,0); % generate mesh grid for detector position
%[xs,ys,zs]=meshgrid(60*ones(1,nd),178*ones(1,nd),82); %generate mesh grid for source position
 %lxs = 16.4;lys = 55; lzs = 17.16;
% xs = lxs/p;ys = lys/p;zs = lzs/p; % in pixel unit
xs = nd./2;ys = nd./2;zs = 17./p; % in pixel unit
xd = xd(:); yd = yd(:); zd = zd(:);
r = sqrt((xd-xs).^2 + (yd-ys).^2 + (zd-zs).^2); % Distance from source
rlateral = sqrt((xd-xs).^2 + (yd-ys).^2);
%r=sqrt((xd(:,:,1)-xs(:,:,1)).^2+(yd(:,:,1)-ys(:,:,1)).^2+(zd(:,:,1)-zs(:,:,1)).^2);%generate distance between point source and detector position
rho3 = r.*p/10;% convert pixel distance to cm
rho2 = r.*p/10; %convert pixel distance to cm

save rho_values.mat;
