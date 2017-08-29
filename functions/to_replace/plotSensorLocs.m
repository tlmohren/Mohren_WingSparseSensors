function  plotSensorLocs( binar,par)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



sensorloc_tot = reshape(binar,par.chordElements,par.spanElements); 

imshow((1-sensorloc_tot), 'InitialMagnification', 'fit')
set(gca,'YDir','normal')
hold on 

rectangle('Position',[0.5,0.5,par.spanElements,par.chordElements])
% rectangle('Position',[0.5,par.chordElements+0.5,par.spanElements,par.chordElements])
h = gca;  % Handle to currently active axes
set(h, 'YDir', 'reverse');


end

