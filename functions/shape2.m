function [shape] = shape2(xi,eta,xpos,ypos,a,b)
 
shape =[1/8*(1+xpos/a*xi)*(1+((ypos/b)-1)*eta)*(2+xpos/a*xi+((ypos/b)-1)*eta-xi^2-eta^2);
    b/8*xpos/a*(1+xpos/a*xi)^2*(((ypos/b)-1)*eta+1)*(xpos/a*xi-1);
    a/8*(xpos/a*xi+1)*(eta*((ypos/b)-1)-1)*(1+((ypos/b)-1)*eta)^2];


