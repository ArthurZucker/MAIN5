function condp=condp(p,x)
p=sym(p,'f');
x= sym(x,'f');
s1 = 0;
s2 = 0;
for i=1:length(p)
    s1 = s1 + abs(p(i))*(abs(x)^i);
    s2 = s2 + p(i)*(x^i);
end
s2 = abs(s2);
condp = s1/s2;
end