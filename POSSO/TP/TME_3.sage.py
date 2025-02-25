

# This file was *autogenerated* from the file TME_3.sage
from sage.all_cmdline import *   # import sage library

_sage_const_6 = Integer(6); _sage_const_4 = Integer(4); _sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_5 = Integer(5); _sage_const_20 = Integer(20); _sage_const_0 = Integer(0)
R = QQ ['x, y']; (x, y,) = R._first_ngens(2)
f = _sage_const_6 *x**_sage_const_4 *y**_sage_const_3  + _sage_const_2 *x**_sage_const_3 *y**_sage_const_2  + _sage_const_4 *x**_sage_const_2 *y + x + _sage_const_2 
g = _sage_const_2 *x**_sage_const_3  + x**_sage_const_2  + _sage_const_6 *x + _sage_const_1 

f2 = _sage_const_3 *x**_sage_const_5  + _sage_const_6 *x**_sage_const_3 *y + _sage_const_4 *x**_sage_const_2  + x*y + _sage_const_20 
g2 = _sage_const_2 *x**_sage_const_3  + _sage_const_2 *x**_sage_const_2 *y + _sage_const_2 *x*y**_sage_const_2  + _sage_const_5 

print("f = {}".format(f))
print("g = {}".format(g))
print("f2 = {}".format(f2))
print("g2 = {}".format(g2))


print("\n-------------------- dim > 0 ? --------------------\n")

def dim_sup_0(A,B):
  if(A.resultant(B, x)==_sage_const_0 ):
    return true
  if(A.resultant(B, y)==_sage_const_0 ):
    return true
  return false

print("La dimension de la variété algébrique définie par f et g est-elle supérieure à 0 ? ")
print(dim_sup_0(f,g))

print("La dimension de la variété algébrique définie par f2 et g2 est-elle supérieure à 0 ? ")
print(dim_sup_0(f2,g2))

print("\n-------------------- dim = -1 ? --------------------\n")

#montrer qu'il n'y pas racine pour les resultants
def dim_vide(A,B):
  res1 = A.resultant(B, x)
  res1 = res1.univariate_polynomial()
  roots1 = res1.roots()
  res2 = A.resultant(B, y)
  res2 = res2.univariate_polynomial()
  roots2 = res2.roots()

  if((not roots1) and (not roots2)):
    return true
  else:
    return false

print("La variété algébrique définie par f et g est-elle vide ? ")
print(dim_vide(f,g))

print("La variété algébrique définie par f2 et g2 est-elle vide ? ")
print(dim_vide(f2,g2))

print("\n-------------------- dim = 0 ? --------------------\n")

def dim_0(A,B):
  if(not dim_vide(A,B) and not dim_sup_0(A,B)):
    return true
  return false

print("La dimension de la variété algébrique définie par f et g est-elle égale à 0 ? ")
print(dim_0(f,g))

print("La dimension de la variété algébrique définie par f2 et g2 est-elle égale à 0 ? ")
print(dim_0(f2,g2))

print("-"*_sage_const_20 +"Exercice 5 cours 2"+"-"*_sage_const_20 )
f3 = x**_sage_const_2 +y**_sage_const_2 -_sage_const_1 
g3 = x**_sage_const_2 -_sage_const_2 *y**_sage_const_2 +_sage_const_2 

print("f3 = {}".format(f3))
print("g3 = {}".format(g3))
print("dim(V(f3,g3))>0? : {}".format(dim_sup_0(f3,g3)))

f4 = x**_sage_const_3  + x*y**_sage_const_2  -x
g4 = x**_sage_const_2   - x*y

print("f4 = {}".format(f4))
print("g4 = {}".format(g4))
print("dim(V(f4,g4))>0? : {}".format(dim_sup_0(f4,g4)))

