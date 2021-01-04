function res = SCompSum(p)
n=length(p);
o = 0;
e = 0;
for i = 1:n
    y = p(i) + e;
    [o, e] = FastTwoSum(o, y);
end
res = o;
end
