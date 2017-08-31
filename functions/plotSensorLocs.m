function  plotSensorLocs( binar,fixPar)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



sensorloc_tot = reshape(binar,fixPar.chordElements,fixPar.spanElements); 

imshow((1-sensorloc_tot), 'InitialMagnification', 'fit')
set(gca,'YDir','normal')
hold on 

rectangle('Position',[0.5,0.5,fixPar.spanElements,fixPar.chordElements])
% rectangle('Position',[0.5,par.chordElements+0.5,par.spanElements,par.chordElements])
h = gca;  % Handle to currently active axes
set(h, 'YDir', 'reverse');


end

