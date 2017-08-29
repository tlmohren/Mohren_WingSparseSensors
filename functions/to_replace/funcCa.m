function [Ca] = funcCa(v0,w)

Ca = [-v0(2) v0(1) 0;
      0 0 -w(1);
      0 0 -w(2)];
  