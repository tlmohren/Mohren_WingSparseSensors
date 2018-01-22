function  plotSensorLocs( binar,fixPar)
% plotSensorLocs plots the probability density function of sensors on the
% wing 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

sensorloc_tot = reshape(binar,fixPar.chordElements,fixPar.spanElements); 

imshow((1-sensorloc_tot), 'InitialMagnification', 'fit')
set(gca,'YDir','normal')
hold on 

rectangle('Position',[0.5,0.5,fixPar.spanElements,fixPar.chordElements])
h = gca;  % Handle to currently active axes
set(h, 'YDir', 'reverse');

