function [ mueffexpt, muefferror ] = mueffcalculator(nd,p, xs, ys, zs, background, imagedata, dist, muaref, musref, threshold)

% input xs ys zs imagedata muaref musref
% output mueff muaexpt muerror 

[xd,yd,zd]=meshgrid(0:1:nd-1,0:1:nd-1,0); % generate mesh grid for detector position
xd = xd(:); yd = yd(:); zd = zd(:);
r = sqrt((xd-xs).^2 + (yd-ys).^2 + (zd-zs).^2); % Distance from source
rho = r.*p/10;% convert pixel distance to cm

imagedatafilt = imsubtract(imagedata,background);
imagedatafilt(imagedatafilt<threshold)=0;

imagedatamod = double(imagedatafilt(:));
fluence = log((rho.^2).*imagedatamod);

%roidistance = find(rho>dist);
rhomod = rho;
rhomod(rho>dist)=[];
fluencemod = fluence;
fluencemod(rho>dist)=[];

beta = polyfit(rhomod,fluencemod,1);
mueffexpt = -(beta(1));
mueffref = sqrt(3*muaref*musref);
%muaexpt = mueff.^2/(3*musref);
muefferror = 100*(abs(mueffexpt-mueffref))/mueffref;
end

