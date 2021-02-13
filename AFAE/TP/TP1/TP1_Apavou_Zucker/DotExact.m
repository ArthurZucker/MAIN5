function res = DotExact(x,y)
xaux = sym(x,'f');
yaux = sym(y,'f');
res = double(xaux*yaux);
end
