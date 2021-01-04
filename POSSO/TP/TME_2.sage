###
### Auteurs : Clément Apavou & Arthur Zucker
###

print("\n-------------------- Algorithme d'Euclide sur les entiers --------------------\n")

def Euclide_entier(a,b):
  if(a>b):
    s = a
    t = b
    while(t != 0):
      r = s % t
      s = t
      t = r
    return s
  else:
    s = b
    t = a
    while(t != 0):
      r = s % t
      s = t
      t = r
    return s

a = 20
b = 2
res = Euclide_entier(20,2)
print("Le pgcd de {} et {} est {}".format(a,b,res))

print("\n-------------------- Algorithme d'Euclide polynômes --------------------\n")

def Euclide_polynome(A,B):
  S = A
  T = B
  while(T!=0):
    R = S % T
    S = T
    T = R
  return S

R.<x> = QQ []
f = 6*x^4 + 2*x^3 + 4*x^2 + x + 2
g = 2*x^3 + x^2 + 6*x + 1

res = Euclide_polynome(f,g)
print("Le pgcd de {} et {} est  {}".format(f,g,res))
print("vérification avec sage : {}".format(f.gcd(g)))
print("\n-------------------- Calcul du resultant --------------------\n")

R.<x> = QQ []
f1 = 3*x^4 + 6*x^3 + 2*x^2 + x + 3
g1 = 2*x^3 + 6*x + 1

A = x^2 - 2*x + 1
B = x^2 - 1

f2 = 3*x^5 + 1*x^4 + 4*x + 2
g2 = 2*x^3 + x^2 + 6*x + 1

def calcul_res(A,B):
  p = A.degree()
  q = B.degree()
  if(A.degree()<B.degree()):
    return calcul_res(B,A)*(-1)^(p*q)
  if(B.degree() > 0):
    R = A%B
    rho = R.degree()
    bq = B.leading_coefficient()
    return (-1)^(p*q) * bq^((p-rho))*calcul_res(B,R)
  else:
    return B^(p)

print("f1 = {}".format(f1))
print("g1 = {}".format(g1))
print("f2 = {}".format(f2))
print("g2 = {}".format(g2))
print("A  = {}".format(A))
print("B  = {}".format(B))
res1 = calcul_res(f1,g1)
res2 = calcul_res(g1,f1)
res3 = calcul_res(A,B)
res4 = calcul_res(B,A)
res5 = calcul_res(f2,g2)
res6 = calcul_res(g2,f2)

print("res(f1,g1) = {}".format(res1))
print("res(g1,f1) = {}".format(res2))
print("res(A,B)   = {}".format(res3))
print("res(B,A)   = {}".format(res4))
print("res(f2,g2) = {}".format(res5))
print("res(g2,f2) = {}".format(res6))
