function res = TSum(p)
p = sym(p,'f');
n=length(p);
o = 0;
for i = 1:n
    o = o + p(i);
res = o;
end     