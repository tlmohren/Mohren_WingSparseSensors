function [N] = shapefunc2(a,b,nodes,xpos,ypos)

syms x y 

xi = x/a;
eta = y/b-1;

for i = 1:nodes 
    N(i,:) = shape2(xi,eta,xpos(i),ypos(i),a,b);
end 

