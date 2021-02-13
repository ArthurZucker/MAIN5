function res = DCompSum(p)
n=length(p);
[out,idx] = sort(abs(p),'descend');
p = p(idx);
s = 0;
c = 0;
for i = 1:n
    [y, u] = FastTwoSum(c, p(i));
    [t, v] = FastTwoSum(s, y);
    z = u + v;
    [s, c] = FastTwoSum(t, z);
end
res = s;
end