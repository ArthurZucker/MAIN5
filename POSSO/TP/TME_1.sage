###
### Auteurs : Clément Apavou & Arthur Zucker
###

import itertools

print("-------------------- Genérer des monômes --------------------\n")
def generer_monomes(n,d):
  combination = list(itertools.combinations_with_replacement(range(d+1), n))
  monomes = []

  for i in range(len(combination)):
    if(sum(combination[i])==d):
      monomes = monomes + list(itertools.permutations(combination[i]))

  res = list(set(monomes))
  if(len(res) == binomial(n+d-1,d)):
    print("On a bien généré le bon nombre de monomes")
  return res

n = 3
d = 3
print("Tous les monômes de degré {} en {} variables : ".format(n,d))
res = generer_monomes(n,d)
print(res)


print("\n-------------------- Genérer des monômes 2 --------------------\n")
def generer_monomes_2(n1,d1,n2,d2):
  res3 = []
  res1 = generer_monomes(n1,d1)
  res2 = generer_monomes(n2,d2)
  print(res1)
  print(res2)
  if(n1>n2):
    for i in res1:
      for j in res2:
        temp = list(i)
        for s in range(n2):
          temp[s] += (j[s])
        res3.append(tuple(temp))
  return res3

n1 = 3
d1 = 3
n2 = 2
d2 = 2
res = generer_monomes_2(n1,d1,n2,d2)

print("Tous les monômes de degré {} en {} variables et {} en {} variables : ".format(n1,d1,n2,d2))
print(res)

print("\n-------------------- Somme de deux polynômes --------------------\n")
# les deux en n variables
def somme_polynômes(p1,p2):
  p3 = []
  coeff = []
  monomes = []
  if(len(p1[0])>len(p2[0])):
    for i in range(len(p2[0])):
      if(p1[1][i]==p2[1][i]):
        coeff.append(p1[0][i]+p2[0][i])
        monomes.append(p1[1][i])
      else:
        coeff.append(p1[0][i])
        monomes.append(p1[1][i])
        coeff.append(p2[0][i])
        monomes.append(p2[1][i])
    monomes = monomes + p1[1][len(p2[0]):len(p1[0])]
    coeff = coeff + p1[0][len(p2[0]):len(p1[0])]
  else:
    for i in range(len(p1[0])):
      if(p1[1][i]==p2[1][i]):
        coeff.append(p1[0][i]+p2[0][i])
        monomes.append(p1[1][i])
      else:
        coeff.append(p1[0][i])
        monomes.append(p1[1][i])
        coeff.append(p2[0][i])
        monomes.append(p2[1][i])
    monomes = monomes + p2[1][len(p1[0]):len(p2[0])]
    coeff = coeff + p2[0][len(p1[0]):len(p2[0])]

  p3.append(coeff)
  p3.append(monomes)
  return p3

p1 = [[1,2,3]]
p2 = [[1,2,3,4]]
p1.append(generer_monomes(2,2))
p2.append(generer_monomes(2,3))

print("p1 = {}".format(p1))
print("p2 = {}".format(p2))

print("Somme de p1 et p2 : ")
p3 = somme_polynômes(p1,p2)
print("p3 = {}".format(p3))
print("\n-------------------- Multiplication de deux polynômes --------------------\n")
import operator

# les deux en n variables
def multiplication_polynômes(p1,p2):
  p3 = []
  coeff = []
  monomes = []
  nb_variable = len(p1[1][0])
  #print(nb_variable)
  for i in range(len(p1[0])):
    for j in range(len(p2[0])):
      coeff.append(p1[0][i]*p2[0][j])
      monomes.append(tuple(map(operator.add, p1[1][i], p2[1][j])))

  p3.append(coeff)
  p3.append(monomes)
  return p3

p1 = [[1,2,3]]
p2 = [[1,2,3,4]]
p1.append(generer_monomes(2,2))
p2.append(generer_monomes(2,3))

print("p1 = {}".format(p1))
print("p2 = {}".format(p2))

print("Multiplication de p1 et p2 : ")
p3 = multiplication_polynômes(p1,p2)
print("p3 = {}".format(p3))
