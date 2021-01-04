###
### Auteurs : Clément Apavou & Arthur Zucker
###

from random import randint

n = 5
# m = [degre var1, degre var2, ...., degre var n]
m1 = [1,1,2,4,5]
#m2 = [1,5,6,5,5]
m2 = [1,2,1,4,5]
m1_alea = [randint(0,10) for i in range(n)]
m2_alea = [randint(0,10) for i in range(n)]

print("-----------------------Ordre lexicographique (LEX)-----------------------")
# Plus le degré en x_1 est grand, plus le monôme est grand. À degrés en x_1 égaux, on effectue la même comparaison mais en x_2, et ainsi de suite.
def ordre_lex(m1,m2):
    """ Le monomes sont codés sour forme de liste d'entier
    """
    for i in range(len(m1)):
        if(m1[i]>m2[i]):
            return("lex : m1>m2")
        elif(m1[i]<m2[i]):
            return("lex : m1<m2")

def ordre_lex2(m1,m2):
    """ Le monomes sont codés sour forme de produit de variables 
    élevées à des puissances entières
    """
    for i in range(len(m1)):
        if(m1[i]>m2[i]):
            return("lex : m1>m2")
        elif(m1[i]<m2[i]):
            return("lex : m1<m2")

print("\n")
print("m1 = {}, m2 = {}, {}".format(m1,m2,ordre_lex(m1,m2)))
print("m1_alea = {}, m2_alea = {}, {}".format(m1_alea,m2_alea,ordre_lex(m1_alea,m2_alea)))
print("\n")

print("-----------------------Ordre lexicographique inverse (REVLEX)-----------------------")
# Plus le degré en x_n, est grand, plus le monôme est petit. À degré en x_n égaux, on effectue la même comparaison mais en x_{n-1}, et ainsi de suite.
def ordre_revlex(m1,m2):
    for i in range(len(m1)-1,-1,-1):
        if(m1[i]>m2[i]):
            return("revlex : m1<m2")
        elif(m1[i]<m2[i]):
            return("revlex : m1>m2")

print("\n")
print("m1 = {}, m2 = {}, {}".format(m1,m2,ordre_revlex(m1,m2)))
print("m1_alea = {}, m2_alea = {}, {}".format(m1_alea,m2_alea,ordre_revlex(m1_alea,m2_alea)))
print("\n")

print("-----------------------Ordre du degré gradué lexicographique inverse (GREVLEX)-----------------------")
def ordre_grevlex(m1,m2):
    sum_deg_m1 = sum(m1)
    sum_deg_m2 = sum(m2)
    print("m = {}, sum(m) = {}".format(m1,sum_deg_m1))
    print("m = {}, sum(m) = {}".format(m2,sum_deg_m2))
    if(sum_deg_m1>sum_deg_m2):
        return("grevlex : m1>m2")
    elif(sum_deg_m1<sum_deg_m2):
        return("grevlex : m1<m2")
    else:
        for i in range(len(m1)-1,-1,-1):
            if(m1[i]>m2[i]):
                return("grevlex : m1<m2")
            elif(m1[i]<m2[i]):
                return("grevlex : m1>m2")

print("\n")
print("m1 = {}, m2 = {}, {}".format(m1,m2,ordre_grevlex(m1,m2)))
print("m1_alea = {}, m2_alea = {}, {}".format(m1_alea,m2_alea,ordre_grevlex(m1_alea,m2_alea)))
print("\n")

# p = [(coefficient terme, [degres de chaque variable dans le monome]),....,]
p1 = [(3,[1,1,2,4,5]), (5,[1,3,3,4,5]), (2,[3,3,1,5,4])] 
p2 = [(9,[1,0,3,0,6]), (8,[2,0,3,2,5]), (1,[6,5,8,3,0])]
nb_monome = 5
nb_variable = 6
p_alea =[(randint(0,10),[randint(0,10) for j in range(nb_variable)]) for i in range(nb_monome)]

print("-----------------------Terme dominant pour l'ordre lexicographique (LEX)-----------------------")
def terme_dominant_lex(p):
    monome_dominant_lex = p[0][1] # premier monome du polynomes
    index_terme_dominant_lex = 0
    for i in range(1,len(p)):
        res = ordre_lex(monome_dominant_lex,p[i][1])
        if(res == "lex : m1<m2"):
            monome_dominant_lex = p[i][1]
            index_terme_dominant_lex = i
    return p[index_terme_dominant_lex]
        

print("\n")
print("terme dominant pour l'ordre lexicographique de {} est {}".format(p1,terme_dominant_lex(p1)))
print("terme dominant pour l'ordre lexicographique de {} est {}".format(p2,terme_dominant_lex(p2)))
print("terme dominant pour l'ordre lexicographique de {} est {}".format(p_alea,terme_dominant_lex(p_alea)))
print("\n")

print("-----------------------Terme dominant pour l'ordre du degré gradué lexicographique inverse (GREVLEX)-----------------------")
def terme_dominant_grevlex(p):
    print("Determiner le terme dominant grevlex de {}".format(p))
    monome_dominant_grevlex = p[0][1] # premier monome du polynomes
    index_terme_dominant_grevlex = 0
    for i in range(1,len(p)):
        print("ordre grevlex entre {} et {}".format(monome_dominant_grevlex,p[i][1]))
        res = ordre_grevlex(monome_dominant_grevlex,p[i][1])
        print("resultat = {}".format(res))
        if(res == "grevlex : m1<m2"):
            monome_dominant_grevlex = p[i][1]
            index_terme_dominant_grevlex = i
    return p[index_terme_dominant_grevlex]
        
print("\n")
print("terme dominant pour l'ordre du degré gradué lexicographique inverse de {} est {}".format(p1,terme_dominant_grevlex(p1)))
print("\n")
print("terme dominant pour l'ordre du degré gradué lexicographique inverse de {} est {}".format(p2,terme_dominant_grevlex(p2)))
print("\n")
print("terme dominant pour l'ordre du degré gradué lexicographique inverse de {} est {}".format(p_alea,terme_dominant_grevlex(p_alea)))
print("\n")

print("----------------------- Division d'un polynôme par une famille de polynômes-----------------------")
print("\n")

nb_monome = 5
nb_variable = 2
nb_polynome = 2
p = [(randint(0,10),[randint(0,10) for j in range(nb_variable)]) for i in range(nb_monome)]
list_p = [[(randint(0,10),[randint(0,10) for j in range(nb_variable)]) for i in range(nb_monome)] for i in range(nb_polynome)]
print(list_p)

def divide(m1,m2):
    # determine si m1 divises m2
    #to do
    if(r==0):
        return true
    return false

def multiplication(m1,m2):
    # calcul la multiplication de monome : m1 x m2
    coeff = m1[0]*m2[0]
    monome = []
    for i in range(len(m1[1])):
        monome.append(m1[1][i]+m2[1][i])
    return (coeff,monome)

def addition(m1,m2):
    # calcul l'addtion de monome : m1 + m2
    p = []
    meme_deg = true
    for i in range(len(m1[1])):
        if(m1[1][i]!=m2[1][i]):
            meme_deg = false 
            break
    if(meme_deg == true):
        p.append((m1[0]+m2[0],m1[1]))
    else:
        p.append(m1)
        p.append(m2)
    return p

def soustraction(m1,m2):
    # calcul la soustraction de monome : m1 - m2
    p = []
    meme_deg = true
    for i in range(len(m1[1])):
        if(m1[1][i]!=m2[1][i]):
            meme_deg = false 
            break
    if(meme_deg == true):
        p.append((m1[0]-m2[0],m1[1]))
    else:
        p.append(m1)
        m_temp = (m2[0]*-1,m2[1])
        p.append(m_temp)
    return p

# def division(m1,m2):
#     # calcul la division m1 par m2
#     #to do
#     return 0

def div_ordre(f,list_p,ordre):
    s = len(list_p)
    q = [0 for i in range(s)]
    r = 0
    p = f
    while(p!=0):
        i = 0 
        division_done = false
        while(i<s and division_done == false):
            fi = list_p[i]
            if(ordre == "lex"):
                LT_fi = terme_dominant_lex(fi) 
                LT_p = terme_dominant_lex(p)
            elif(ordre == "grevlex"):
                LT_fi = terme_dominant_grevlex(fi) 
                LT_p = terme_dominant_grevlex(p)
            if(divide(LT_fi,LT_p) == true):
                q[i] = addition(q[i],division(LT_p,LT_fi))
                p = soustraction(p,multiplication(division(LT_p,LT_fi),fi))
                division_done == true
            else:
                i += 1
        if(division_done == false):
            if(ordre == "lex"):
                LT_p = terme_dominant_lex(p)
            elif(ordre == "grevlex"):
                LT_p = terme_dominant_grevlex(p)
            r = addition(r,LT_p)
            p = soustraction(p,LT_p)
    return r

def division(f,list_p):
    s = len(list_p)
    q = [0 for i in range(s)]
    r = 0
    p = f
    while(p!=0):
        i = 0 
        division_done = false
        while(i<s and division_done == false):
            fi = list_p[i]
            LT_fi = (fi).lc() 
            LT_p = (p).lt()
            #print("degree : ",(LT_p)%LT_fi)
            if((LT_p%LT_fi) == 0): 
                
                q[i] += LT_p/LT_fi
                p    -= (LT_p*fi/LT_fi)
                division_done = true
                print("division done : ",division_done," i ",i )
            else:
                i += 1
        print(p)
        if(division_done == false):
            LT_p = (p).lt()
            r += LT_p
            p -= LT_p
            print(p)
    return r

R.<x, y> = PolynomialRing(QQ, 2,order='lex')
f2 = 3*x^4*y + 7*x^2*y + 2*y^2*x + 1
print(division(f2,[x]))
#print(div_ordre(p,list_p,"lex"))