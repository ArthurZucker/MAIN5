function [p,C] = GenSum(n,c)
[x,y,d,C] = GenDot(n,c);
for i=1:n
	[p(i),p(n+i)] = TwoProduct(x(i),y(i)); 
end
C = condsum(p);
end
