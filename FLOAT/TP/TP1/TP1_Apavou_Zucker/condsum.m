function res = condsum(p)
paux = sym(p,'f');
res = double(sum(abs(paux))/abs(sum(paux)));
end
