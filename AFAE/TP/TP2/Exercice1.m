%% Exercice 1
X = infsup(1,4);
f1 = @(x) x^2 - 4*x;
f2 = @(x) x*(x-4);
f3 = @(x) (x-2).^2 - 4;
disp('Evaluating with X : ');
disp( 'x^2 - 4*x')
f1(X)
disp( 'x*(x-4)')
f2(X)
disp( '(x-2).^2 - 4')
f3(X)
% Pourquoi c'est plus précis
% On a moins d'évaluation de X 

%% Exercice 2
t = NonSingular(magic(20));

%% Exercice 3
%Question 1
clear
%format infsup

format long e

[H,b] = hilbert_and_b(4)
b = b'
x = GaussElimination(H,b)
H*x
% Question 2 

n = 10;
A = 1 + 10*rand(n,n);
R = 1 + 10*rand(n,n);
R = inv(A)
A = H;


% H*x
A = H;
R = inv(H)/50;
a = max(max(abs(R.*b)))/max(max(abs(eye(n)-R*A)));
X = ones(n,1)*[-a, a];
X = linearInter(A,R,b)

function X = linearInter(A,R,b)
n = length(A);
I = eye(n);
g = @(x) R*b + (I-R*A)*x ;
X = GaussElimination(A,b);  % solution de départ
disp("Initialisation, g(X) inclus dans X")
disp(in(g(X),X))
i = 0;
while sum(in0(g(X),X))<4 && i<1000% tant qu'on a pas l'inclusion des deux ensembles 
    X = g(X);           % méthode du point fixe
    i=i+1;                              % compte le nombre d'itérations
end
X = g(X);               % On prends l'exclusion de l'interval
disp("Nombres d'itérations "+ i)
disp("Intervalle contenant la solution finale: X = ")
disp(X)
disp("interval Y = g(X) qui doit être inclus dans X : Y = ")
disp(g(X))
disp("verifions l'inclusions")
disp(in0(g(X),X))
=======
H = hilb(n)
H = R
figure(1)
gershdisc(H)
C1 = GerschgorinCircles(H)
figure(2)
gershdisc(H')
C2 = GerschgorinCircles(H')
function de = GerschgorinCircles(A)

n = length(A);
R = zeros(n,1);

for i = 1 : n
    for j = 1 : n
        if(i~=j)
            R(i) = R(i)+abs(A(i,j));
        end
    end
end

superficie = zeros(n,1);
for i = 1 : n
     superficie(i) = pi*R(i)^2;
end
superficie;
index = find(superficie == max(superficie))
val_exacte = eig(A)
val_propre = intval(zeros(n,1));
for i = 1 : n
    a = A(i,i)-R(i);
    b = A(i,i)+R(i);
    int = infsup(a,b);
    val_propre(i) = int;
end
val_propre
de = prod(val_propre);
end

function gershdisc(A)
error(nargchk(nargin,1,1));
if size(A,1) ~= size(A,2)
    error('Matrix should be square');
    return;
end
% For each row, we say:
for i=1:size(A,1)
    % The circle has center in (h,k) where h is the real part of A(i,i) and
    % k is the imaginary part of A(i,i)   :
    h=real(A(i,i)); k=imag(A(i,i)); 
    
    % Now we try to compute the radius of the circle, which is nothing more
    % than the sum of norm of the elements in the row where i != j
    r=0;
    for j=1:size(A,1)
       if i ~= j 
           r=r+(norm(A(i,j)));
       end    
    end 
    
    % We try to make a vector of points for the circle:
    N=256;
    t=(0:N)*2*pi/N;
    
    % Now we're able to map each of the elements of this vector into a
    % circle:
    plot( r*cos(t)+h, r*sin(t)+k ,'-');
    % We also plot the center of the circle for better undesrtanding:
    hold on;
    plot( h, k,'+');
end
% For the circles to be better graphed, we would like to have equal axis:
axis equal;
% Now we plot the actual eigenvalues of the matrix:
ev=eig(A);
for i=1:size(ev)
    rev=plot(real(ev(i)),imag(ev(i)),'ro');
end
hold off;
legend(rev,'Actual Eigenvalues');

end

function y = g(X,A,R,b)
    n = length(A);
    y = R*b + ( eye(n) - R*A)*X;
end

function X = ExactSol2(A,R,b)
n = length(A);
I = eye(n);
a = norm(R*b,inf)/(1-norm(I-R*A,inf))
int = [a,-a];
X = ones(1,n)'*int
%X = GaussElimination(A,b);

g = @(x) R*b + (I-R*A)*x ;
i = 0;
while ~in(g(X),X)
    X = g(X)
    i = i+1
end

"itérations : " + i 
"g(x) in X?" + in(X,g(X))

end




    
    
function t= NonSingular(A)
    R = inv(A);
    C = eye(length(A)) - R*intval(A); 
    t = ( norm(C,1) < 1 );
end

function [H,b] = hilbert_and_b(n)
for i = 1:n
    for j = 1:n
        H(i,j) = intval(1/(i+j-1));
    end
    b(i) = intval(i);
end
end

function x = GaussElimination(A,b)
    
    size_A = size(A);
    n = size_A(1);
    if (size_A(2)~=n)
        return
    end 
    
    if(~NonSingular(A))
        return
    end
    
    A = intval(A);
    b = intval(b);
    A(:,n+1) = b; 
    
    for k = 1 : n   
        if A(k,k)==0 
            if k<n 
                i=k+1;
                while(A(i,k)==0 && i<n ) 
                    i=i+1; 
                end
            else
                i=k;
            end
            A([k,i],:)=A([i,k],:);
        end
        A(k,k:n+1) = A(k,k:n+1)/A(k,k);
        for i = k+1 : n 
            A(i,k:n+1) = A(i,k:n+1) - A(i,k)*A(k,k:n+1);
        end
    end
    for i = n-1:-1:1
        A(i,n+1) = (A(i,n+1) - A(i,i+1:n)*A(i+1:n,n+1));
    end
    x = A(:,n+1);
end
