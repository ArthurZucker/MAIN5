###
### Auteurs : Clément Apavou & Arthur Zucker
###

from math import sqrt
import numpy as np

def calcul_res_with_sous_res(a,b,var):
  """ compute the resultant of A and B with respect to var in a Euclidian Ring.
  The method uses pseudo remainders, which prevent the appearance of denominators.
  """
  f=1
  g=1
  s=1
  i = 0
  subres = []
  while(b.degree(var)>0):
    print("deg(a) : ",a.degree(var)," deg(b) : ",b.degree(var))
    d = a.degree(var)-b.degree(var)
    if(d<0):
        temp = a
        a = b
        b = temp
        d = a.degree(var)-b.degree(var)
    h2 = l_c(b,var) # used to compute pseudo remainder r
    print("h2 = ",h2)
    print("d : ",d,"\na : ",a,"\nb : ",b)
    print(h2^(d+1)*a)
    r = (h2^(d+1)*a)%b #%b              # h2^(n-m+1)a = qb + r <=> r =  h2^(n-m+1)a % b
    print("r = ",r)
    _,r = (h2^(d+1)*a).quo_rem(b)
    print("r = ",r)
    
    if(a.degree(var)%2==1 and b.degree(var)%2==1):
      s = -1*s
    a = b
    b = r / (f*g^d)
    print("new b : ",b)
    subres.append(b)
    f = l_c(a,var)
    g = (f^d)/(g^(d-1))
    i = i + 1
  d = a.degree(var)
  return s*(b^d)/(g^(d-1)),subres

def HasPositiveDimension(f1,f2):
    resx = f1.resultant(f2, x)
    if(resx == 0):
        if(f1==0 and f2==0):
            return 2
        else:
            return 1
    resy = f1.resultant(f2, y)
    if(resy == 0): 
        if(f1==0 and f2==0):
            return 2
        else:
            return 1
    return false

def is_empty(A,B):
  lc_A = l_c(A,y)
  lc_B = l_c(B,y)
  if(gcd(lc_A,lc_B)!=1):
    return false
  res = A.resultant(B,y)
  if(res.degree(x)==0 and res!=0):
    return -1
  else:
    return false

def ComputeDimension(f1,f2):
    "it outputs an integer d which is the dimension of the algebraic set"
    d = HasPositiveDimension(f1,f2)
    print("In ComputeDimension, d : ",d)
    if (d==false):
        d = is_empty(f1,f2)
        print(d)
        if(d==false):
            return 0
    return d

# version clement 
# def ApplyChangeOfVariables(f1,f2,A):
#     "det(A) !=0"  
#     #c1 = f1.coefficients(x)
#     print(A) 
#     while(A.determinant()==0): 
#         A=random_matrix(ZZ,2,2)
#     #a = A[0][0]
#     #b = A[0][1]
#     #c = A[1][0]
#     #d = A[1][1]
#     #for coeff_f1 in c1 :
#     #    p1 = coefc1[1]
#     #    c2 = coefc1[0].coefficients[v2]
#     x1 = var('x1')
#     x2 = var('x2')
#     l1,l2 = A*(x1,x2)
#     print(l1,l2)
    
# version art
def ApplyChangeOfVariables(f1,f2,A):
    "det(A) !=0"  
    assert(A.determinant() != 0)
    x,y = f1.variables()
    l1 = A[0][0]*x + A[0][1]*y
    l2 = A[1][0]*x + A[1][1]*y
    return f1(l1,l2),f2(l1,l2)


def bivariate_solve(f1,f2,x,y):
    d = ComputeDimension(f1,f2)
    if (d == -1):
        return (-1,[1])
    if (d == 2 ):
        return (2,[0])
    if (d == 1):
        g = f1.gcd(f2)
        return (1,[g])
    A = matrix.identity(2)
    lc_f1 = l_c(f1,y)
    lc_f2 = l_c(f2,y)
    g = lc_f1.gcd(lc_f2)
    while (g.degree()>0):
        B = random_matrix(ZZ,2,2)
        while(B.determinant()==0): 
            B = random_matrix(ZZ,2,2)
        A = A*B
        f1,f2 = ApplyChangeOfVariables(f1,f2,B)
        lc_f1 = l_c(f1,y)
        lc_f2 = l_c(f2,y)
        g = lc_f1.gcd(lc_f2)
    temp,subres = calcul_res_with_sous_res(f1,f2,y)
    subres = numpy.array(subres)
    si = np.min(subres[np.nonzero(subres)])
    si_tilde = prod( [ factor for (factor,power) in si.factor() ] ) # square-free part of si
    while(si_tilde.degree()>1):
        B = random_matrix(ZZ,2,2)
        A = A*B
        f1,f2 = ApplyChangeOfVariables(f1,f2,B)
        lc_f1 = l_c(f1,y)
        lc_f2 = l_c(f2,y)
        g = lc_f1.gcd(lc_f2)
        while (g.degree()>0):
            B = random_matrix(ZZ,2,2)
            while(B.determinant()==0): 
                B = random_matrix(ZZ,2,2)
            A = A*B
            f1,f2 = ApplyChangeOfVariables(f1,f2,B)
            lc_f1 = l_c(f1,y)
            lc_f2 = l_c(f2,y)
            g = lc_f1.gcd(lc_f2)
        temp,subres = calcul_res_with_sous_res(f1,f2,y)
        subres = numpy.array(subres)
        si = np.min(subres[np.nonzero(subres)])
        si_tilde = prod( [ factor for (factor,power) in si.factor() ] )
    return (si_tilde,subres[0])

def l_c(f1,y):
    return f1.coefficient({y:f1.degree(y)})
    
#R.<x, y> = PolynomialRing(QQ, 2,order='lex')
#x = var('x')
#y = var('y')
R.<x,y> = QQbar[]
f1 = 4*x^5*y^2 + 10*x*y^2 + 4*x^2*y + 3*y^3
f2 = 3*x^4*y + 7*x^2*y + 2*y^2*x + 1
A = random_matrix(ZZ,2,2)
#print(ComputeDimension(f1,f2))
#print(ApplyChangeOfVariables(f1,f2,A))
#print(f1.subresultants(f2,y))
#print(f1.leading_coefficient(x))
#print(f1.quo_rem(f2))
temp,subres = calcul_res_with_sous_res(f1,f2,y)
print(subres)
print(temp)
print(f1.resultant(f2,y))