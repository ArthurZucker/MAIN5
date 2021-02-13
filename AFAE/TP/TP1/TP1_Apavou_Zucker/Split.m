function [x, y] = Split(a) 
factor = 2^(27) +1; %u=2−p , s=⌈p/2⌉
c = factor * a;
x = c - (c - a); 
y =a-x;
end