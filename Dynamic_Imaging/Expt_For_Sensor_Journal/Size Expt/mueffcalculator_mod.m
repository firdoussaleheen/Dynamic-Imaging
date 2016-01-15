function [mueffexpt] = mueffcalculator_mod(imagedata, musref, distthreshold)

% input xs ys zs imagedata muaref musref
% output mueff muaexpt muerror 


imagedatamod = double(imagedatafilt(:));
fluence = log((rho.^2).*imagedatamod);

%roidistance = find(rho>dist);
rhomod = rho;
rhomod(rho>distthreshold)=[];
fluencemod = fluence;
fluencemod(rho>dist)=[];

beta = polyfit(rhomod,fluencemod,1);
mueffexpt = -(beta(1));
muaexpt = mueff.^2/(3*musref);
end

