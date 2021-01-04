function res = Horner(p,x)
p = fliplr(p);
n = length(p);
a = p;
s(n) = a(n);
for i = (n-1) : (-1) : 1
    p(i) = s(i+1) * x;  
    s(i) = p(i) + a(i);
end
res = s(1);
end