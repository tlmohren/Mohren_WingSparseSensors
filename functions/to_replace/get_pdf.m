function [ binar ] = get_pdf(Sloc)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    binar = zeros(1326*2,1);
    for j = 1:size(Sloc,2)
        sensors = Sloc(:,j);
        binar(sensors)  = binar(sensors) + 1;
    end
    binar = binar/size(Sloc,2);
% sensor_locs = reshape(binar,26,51); 
% [Xl,Yl]= meshgrid(1:51,1:26);



end

