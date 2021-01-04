###
### Auteurs : Clément Apavou & Arthur Zucker
###

R.<x,y> = QQ []
x = var('x')
y = var('y')
f = 5*x^2*y^3 + 2*x^3*y^2 + 4*x^2*y + x + 2
g = 2*x^3*y^2 + 3*y^3 + 6*x*y + 1

f2 = 3*x^6 + 6*x^3*y + 4*x^2 + x*y + 20
g2 = 2*x^3 + 2*x^2*y + 2*x*y^2 + 5

print("f = {}".format(f))
print("g = {}".format(g))
print("f2 = {}".format(f2))
print("g2 = {}".format(g2))

def Euclide_polynome(A,B):
  S = A
  T = B
  # degrée == -1 correspond à T == 0
  #print("Division de {} par {}".format(A,B))
  while(T.degree(x) >= B.degree(x)):
    R = S%T
    S = T
    T = R
    #print("T = {}, R = {}".format(T,R))
  return S,R

print("\n-------------------- dim > 0 ? --------------------\n")

def dim_sup_0(A,B):
  if(A.resultant(B, x)==0):
    return true
  if(A.resultant(B, y)==0):
    return true
  return false

print("La dimension de la variété algébrique définie par f et g est-elle supérieure à 0 ? ")
print(dim_sup_0(f,g))

print("La dimension de la variété algébrique définie par f2 et g2 est-elle supérieure à 0 ? ")
print(dim_sup_0(f2,g2))

print("\n-------------------- dim = -1 ? --------------------\n")

def is_empty(A,B):
  lc_A = A.leading_coefficient(y)
  lc_B = B.leading_coefficient(y)
  # leading coeff wrt by y coprime?
  if(gcd(lc_A,lc_B)!=1):
    return false
  res = A.resultant(B,y)
  # resultant constant ?
  if(res.degree(x)==0 and res!=0):
    return true
  else:
    return false

print("La variété algébrique définie par f et g est-elle vide ? ")
print(is_empty(f,g))

print("La variété algébrique définie par f2 et g2 est-elle vide ? ")
print(is_empty(f2,g2))

print("\n-------------------- dim = 0 ? --------------------\n")

#def dim_0(A,B):
#  if(not dim_vide2(A,B) and not dim_sup_0(A,B)):
#    return true
#  return false

def dim_0(A,B):
  g = gcd(A,B)# on peut utiliser l'algo d'Euclide implémenté mais il ne marche pas pour des polynomes multivariés (à cause de sagemath)
  if(g == 1):
    return true
  return false

print("La dimension de la variété algébrique définie par f et g est-elle égale à 0 ? ")
print(dim_0(f,g))

print("La dimension de la variété algébrique définie par f2 et g2 est-elle égale à 0 ? ")
print(dim_0(f2,g2))
