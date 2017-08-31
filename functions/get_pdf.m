function [ binar ] = get_pdf(Sloc)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

n_iters = length( nonzeros( Sloc(1,1,1,:)) );
Sloc_sq= squeeze(Sloc);
    binar = zeros(1326*1,1);
    for j = 1:n_iters 
        sensors = Sloc_sq(:,j);
        binar(sensors)  = binar(sensors) + 1/n_iters ;
    end

end

