function res = CompSum(p)
n=length(p);
pi = zeros(1,n);
o = zeros(1,n);
pi(1) = p(1); 
o(1)= 0;
q = zeros(1,n);
for i = 2:n
    [pi(i),q(i)] = TwoSum(pi(i-1), p(i));
    o(i) = o(i-1) + q(i);
end
res = pi(n)+o(n);
end