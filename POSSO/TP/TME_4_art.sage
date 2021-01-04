###
### Auteurs : Clément Apavou & Arthur Zucker
###

from math import sqrt
import numpy as np
verbose = False
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
    # print("deg(a) : ",a.degree(var)," deg(b) : ",b.degree(var))
    d = a.degree(var)-b.degree(var)
    if(d<0):
        temp = a
        a = b
        b = temp
        d = a.degree(var)-b.degree(var)
    h2 = l_c(b,var) # used to compute pseudo remainder r
    # print("h2 = ",h2)
    # print("d : ",d,"\na : ",a,"\nb : ",b)
    # print(h2^(d+1)*a)
    r = (h2^(d+1)*a)%b                # h2^(n-m+1)a = qb + r <=> r =  h2^(n-m+1)a % b
    # print("r = ",r)
    _,r = (h2^(d+1)*a).quo_rem(b)
    # print("r = ",r)
    
    if(a.degree(var)%2==1 and b.degree(var)%2==1):
      s = -1*s
    a = b
    b = r / (f*g^d)
    b = R(b)
    # print("new b : ",b)
    subres.append(b)
    f = l_c(a,var)
    g = (f^d)/(g^(d-1))
    g = R(g)
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
  # if is empty, dimension = -1
  # else, return false as it is not empty  
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
    global verbose
    d = HasPositiveDimension(f1,f2)
    if(verbose) : print("In ComputeDimension, d has positive dimension : ",d)
    if (d==false):
        d = is_empty(f1,f2)
        if(verbose) : print("In ComputeDimension, d is empty               : ",d)
        if(d==false):
            return 0
    return d

def ApplyChangeOfVariables(f1,f2,A):
    """Proceeds the change of virables : [x y]' = Ax[x y]'
    With :               [[A[0][0], A[0][1]]     [x]    [A[0][0]*x + A[0][1]*y]
            Ax[x,y]' =    [A[1][0], A[1][1]]] x  [y] =  [A[1][0]*x + A[1][1]*y]
    Then f1 <- f1(l1,l2)
    and  f2 <- f2(l1,l2)
    f.subs({x1:l1}) could be used if a warning comes
    """
    assert(A.determinant() != 0)
    x,y = f1.variables()
    l1 = A[0][0]*x + A[0][1]*y
    l2 = A[1][0]*x + A[1][1]*y
    #return f1((l1,l2)),f2((l1,l2))
    return f1.subs({x:l1,y:l2}),f2.subs({x:l1,y:l2})


def bivariate_solve(f1,f2,x,y):
    global verbose
    max_iterate = 1000
    i =0
    d = ComputeDimension(f1,f2)
    if(verbose): print("d = {}".format(d))
    if (d == -1):
        return (-1,1)
    if (d == 2 ):
        return (2,0)
    if (d == 1):
        g = f1.gcd(f2)
        return (1,g)
    A = matrix.identity(2)
    lc_f1 = l_c(f1,y)
    lc_f2 = l_c(f2,y)
    if(verbose):
        print("lc_f1 = {}".format(lc_f1))
        print("lc_f2 = {}".format(lc_f2))
    g = lc_f1.gcd(lc_f2)
    if(verbose):
        print("g = {}".format(g))
        print("g degree = {}".format(g.degree()))
    while (g.degree()>0):
        B = random_matrix(ZZ,2,2)
        while(B.determinant()==0): 
            B = random_matrix(ZZ,2,2)
        A = A*B
        f1,f2 = ApplyChangeOfVariables(f1,f2,B)
        if(verbose):
            print("f1 = {}".format(f1))
            print("f2 = {}".format(f2))
        lc_f1 = l_c(f1,y)
        lc_f2 = l_c(f2,y)
        g = lc_f1.gcd(lc_f2)
        if(verbose):
            print("g = {}".format(g))
            print("g degree = {}".format(g.degree()))
        i += 1
        if(i>max_iterate):
            print("Max Loop reach")
            exit(0)
    if(verbose):
        print("g = {}".format(g))
        print("g degree = {}".format(g.degree()))
    temp,subres = calcul_res_with_sous_res(f1,f2,y)
    subres = np.array(subres)
    if(verbose):
        print("subres = {}".format(subres))
    si = np.min(subres[np.nonzero(subres)])
    si_tilde = prod( [ factor for (factor,power) in si.factor() ] ) # square-free part of si
    if(verbose):
        print("si_tilde = {}".format(si_tilde))
        print("is constant?",si_tilde in ZZ)
    if(not si_tilde in ZZ):  # if si_tilde is constant (Integer) than .degree does not work
        while(si_tilde.degree()>1):
            B = random_matrix(ZZ,2,2)
            while(B.determinant()==0): 
                B = random_matrix(ZZ,2,2)
            A = A*B
            if(verbose):
                print("f1 = {}".format(f1))
                print("f2 = {}".format(f2))
            f1,f2 = ApplyChangeOfVariables(f1,f2,B)
            if(verbose):
                print("f1 = {}".format(f1))
                print("f2 = {}".format(f2))
            
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
                i += 1
                if(i>max_iterate):
                    print("Max Loop reach")
                    exit(0)
            temp,subres = calcul_res_with_sous_res(f1,f2,y)
            subres = np.array(subres)
            si = np.min(subres[np.nonzero(subres)])
            si_tilde = prod( [ factor for (factor,power) in si.factor() ] )
            if(verbose):
                print("subres = {}".format(subres))
                print("si_tilde = {}".format(si_tilde))
                print("si_tilde degree : {}".format(si_tilde.degree()))
            i += 1
            if(i>max_iterate):
                print("Max Loop reach")
                exit(0)
    return (subres[-1],si_tilde)

def l_c(f1,y):
    return f1.coefficient({y:f1.degree(y)})


def check_res(r1,r2,r3,r4):
    try:
        assert((r1,r2)==(r3,r4))
        print('\x1b[6;30;42m' + 'Success!' + '\x1b[0m',end = " : ")
        print("The output is correct ")
        return True
    except :
        print('\x1b[6;30;41m' + 'Failure!' + '\x1b[0m',end=" : ")
        print("The result does not match the theorical result")
        print("Result           : ",r1,"\t| ",r2)
        print("Theorical Result : ",r3,"\t| ",r4)
        return False
    
R.<x, y> = PolynomialRing(QQ, 2)
####################################################################
print(50*"_")
print("Exemple DM (lequel??)")
p1 = x^3 + x*y^2 + x^2*y +y^3 
p2 = x^2 + y^2 + 1
temp,subres = calcul_res_with_sous_res(p1,p2,y)
print("p1 = ",p1,"\tp2 = ",p2)
# marche, car passe jamais dans ApplyChangeOfVariables
res1,res2 = bivariate_solve(p1,p2,x,y)
check_res(res1,res2, 2*x^2 + 1,x + y)
print("\tTriangular representation : \n\tw1(x)   : ",res1)
print("\tw2(x,y) : ",res2,"\n"+50*"_"+"\n\n")
####################################################################

####################################################################
# Page 5
# Should return 1 and gcd
# It goes through the applyVariable Function 
print(50*"_")
print("Exemple page 5 cours 3 ")
f3 = (x^2-1)*y
f4 = x^2-1
print("f3 = ",f3,"\tf4 = ",f4)
res1,res2 = bivariate_solve(f3,f4,x,y)
check_res(res1,res2,1,f3.gcd(f4))
print("\tNo Triangular representation : \n\tdimension  = ",res1)
print("\tgcd(f3,f4) = ",res2,"\n"+50*"_","\n\n")
####################################################################

####################################################################
# Page 11
# Should find a representation
# It goes through the applyVariable Function 
print(50*"_")
print("Exemple page 11 cours 3 ")
f3 = x*y-1
f4 = (x^3-x)*y^2+x*y-1
print("f3 = ",f3,"\tf4 = ",f4)
res1,res2 = bivariate_solve(f3,f4,x,y)
if(res1.degree()>0):
    print('\x1b[6;30;42m' + 'Success!' + '\x1b[0m',end = " : ")
    print("The output is correct ")
print("\tOne possible triangular representation : \n\tw1(x)   : ",res1)
print("\tw2(x,y) : ",res2,"\n"+50*"_"+"\n\n")
####################################################################

####################################################################
# Page 2 
# Leads to an empty algeabraic set!
# Should return -1 as the dimension
print(50*"_")
print("Exemple page 2 cours 3 ")
f3 = x*y-1
f4 = x
print("f3 = ",f3,"\tf4 = ",f4)
res1,res2 = bivariate_solve(f3,f4,x,y)
res = check_res(res1,res2,-1,f3.gcd(f4))
if(res):
    print("\tNo Triangular representation : \n\tdimension  = ",res1)
    print("\tgcd(f3,f4) = ",res2,"\n"+50*"_","\n\n")
else:
    print(50*"_","\n\n")
####################################################################

##### NOT WORKING : 

# INFINITE LOOP while the output is known
####################################################################
# expected output : Triangular representation : [-y^4+4*y^2-1 ; x+y^3 - 4*y]
print(50*"_")
print("Exemple page 2 cours 4 , also from cours 1") 
f3 = x^2+y^2-4
f4 = x*y-1
print("f3 = ",f3,"\tf4 = ",f4)
res1,res2 = bivariate_solve(f3,f4,x,y)
res = check_res(res1,res2,-y^4+4*y^2-1,x+y^3 - 4*y)
print("\tOne possible triangular representation : \n\tw1(x)   : ",res1)
print("\tw2(x,y) : ",res2,"\n"+50*"_"+"\n\n")
####################################################################

# Should be empty?? I don't know the actual solution 
####################################################################
# marche pas (tiré de ou cet exemple?)
# f1 = 4*x^5*y^2 + 10*x*y^2 + 4*x^2*y + 3*y^3
# f2 = 3*x^4*y + 7*x^2*y + 2*y^2*x + 1
# print("f1 = ",f1,"\tf2 = ",f2)
# res1,res2 = bivariate_solve(f1,f2,x,y)
# print(res1)
# print(res2)
####################################################################