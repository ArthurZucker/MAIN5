function res = CompHorner(p,x)
p = fliplr(p);
n = length(p);
a = p;
s(n) = a(n);
r(n) = 0;
for i = (n-1) :(-1) : 1
    [p(i),pi(i)] = TwoProduct(s(i+1),x);
    [s(i),si(i)] = TwoSum(p(i),a(i));
    r(i) = (r(i+1)*x+(pi(i)+si(i)));
end
res = s(1) + r(1);
end