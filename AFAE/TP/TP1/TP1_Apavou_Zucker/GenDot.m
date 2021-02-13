function [x,y,d,C] = GenDot(n,c)
%
% input  n dimension of vectors x,y, n>=6
%        c anticipated condition number of x'*y
% output x,y generated vectors
%        d dot product x'*y rounded to nearest
%        C actual condition number of x'*y
%
% uses r=DotExact(x,y) calculating a floating point number r nearest to x'*y
%

	n2 = round(n/2); % initialization
	x = zeros(n,1);
	y = x;
	b = log2(c);
	e = round(rand(n2,1)*b/2);            % e vector of exponents between 0 and b/2
	e(1) = round(b/2)+1;                  % make sure exponents b/2 and
	e(end) = 0;                           % 0 actually occur in e
	x(1:n2) = (2*rand(n2,1)-1).*(2.^e);   % generate first half of vectors x,y
	y(1:n2) = (2*rand(n2,1)-1).*(2.^e);
	
	% for i=n2+1:n and v=1:i, generate x_i, y_i such that (*) x(v)'*y(v) ~ 2^e(i-n2)
	e = round(linspace(b/2,0,n-n2));      % generate exponents for second half
	for i=n2+1:n
		x(i) = (2*rand-1)*2^e(i-n2);       % x_i random with generated exponent
		y(i) = ((2*rand-1)*2^e(i-n2)-DotExact(x',y))/x(i);   % y_i according to (*)
	end
	
	index = randperm(n);                  % generate random permutation for x,y
	x = x(index);                         % permute x and y
	y = y(index);
	d = DotExact(x',y);                   % the true dot product rounded to nearest
	C = 2*(abs(x')*abs(y))/abs(d);        % the actual condition numbero
end
