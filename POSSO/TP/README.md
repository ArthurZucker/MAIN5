# Exercices de programmation relatifs au cours 1.
- [x] Implanter une fonction qui prend en entrée n et d et renvoie tous les monômes en n variables de degré d. Les monômes seront codés sous la forme de tableaux d'entiers. 
- [x] Implanter une fonction prend en entrée des entiers d1, d2, n1, n2 et renvoie tous les monômes de degré d1 en n1 variables et d2 en n2 variables. Comme précédemment les monômes seront codés sous la forme de tableaux d'entiers. 
- [ ] Implanter une fonction qui calcule la somme de deux polynômes. Les polynômes seront donnés par un tableau de leurs coefficients et un tableau des monômes associés à ces coefficients. 
Même question pour la multiplication.

# Exercices de programmation relatifs au cours 2. 
- [X] Implanter l'algorithme d'Euclide (sur les polynômes et sur les entiers). 
- [X] Implanter l'algorithme de calcul du résultant de deux polynômes que vous pouvez déduire de la proposition 25.
- [X] Compute :
  - $x^3+x^2+x+1$ and $x^2+2x+3x+4$;
  - $x^4−x^3+x^2−x+1$ and $4x^3−3x^2+2x−1$.
# Exercices de programmation relatifs au cours 3.
- [X] Implanter un algorithme qui prend en entrée deux polynômes à coefficients entiers, en deux variables, et qui décide si la dimension de la variété algébrique définie par ces deux polynômes est positive (strictement). 
- [ ] Implanter un algorithme qui, pour des polynômes en deux variables, décide si la variété algébrique définie par ces deux polynômes est vide. 
- [ ] Implanter un algorithme, qui pour des polynômes en deux variables, décide si la variété algébrique définie par ces deux polynômes est de dimension zéro.( si ils sont premiers entre eux, dim = 0, si pas premiers entre eux, on sait pas? )

Pour toutes ces implantations, vous pourrez utiliser tout facteur d'accélération, par exemple des réductions modulaires, obtenu par exemple par application des propriétés de spécialisation des résultants. 

# Exercices de programmation relatifs au cours 4.
- [ ] Implanter un algorithme qui prend en entrée deux polynômes à coefficients entiers, en deux variables, et qui résout le système d'equations formé par l'annulation de ces deux polynômes. 
- [ ] Comparer le temps de calcul de votre fonction de résolution avec celui de la fonction de calcul du résultant (dans le système de calcul formel de votre choix). 
- [ ] Modifier votre implantation pour tirer le plus grand profit possible du théorème de spécialisation (en utilisant du calcul modulaire et/ou en utilisant .
Pour toutes ces implantations, vous pourrez utiliser tout facteur d'accélération, par exemple des réductions modulaires, obtenu par exemple par application des propriétés de spécialisation des résultants.


# Exercices de programmation relatifs au cours 5.
- [ ] Implanter une fonction qui prend en entrée deux monômes et compare ces monômes pour l'ordre lexicographique. Vous proposerez deux variantes, l'une prend en entrée les monômes codés sous forme de listes d'entiers, l'autre prend en entrée les monômes codés sous forme de produits de variables élevées à des puissances entières. 
- [ ] Implanter une fonction qui prend en entrée deux monômes et compare ces monômes pour l'ordre du degré gradué lexicographique inverse. Vous proposerez deux variantes, l'une prend en entrée les monômes codés sous forme de listes d'entiers, l'autre prend en entrée les monômes codés sous forme de produits de variables élevées à des puissances entières.
- [ ] Implanter une fonction qui prend en entrée un polynôme et renvoie son terme dominant pour l'ordre lexicographique.
- [ ] Implanter une fonction qui prend en entrée un polynôme et renvoie son terme dominant pour l'ordre du degré gradué lexicographique inverse.
- [ ] Implanter l'algorithme de division d'un polynôme par une famille de polynômes (pour les deux ordres monomiaux mentionnés ci-dessus).


## Problèmes ( clément):

- [ ] ApplyChnageofvariable je sais pas quoi faire
- [ ] calcul_res_with_sous_res il faut faire le reste de la division euclidienne entre deux polynome multivarié je sais pas comment faire (genre le %)
- [ ] leading coeff wrt à une variable ne marche pas quand on declare comme ça R.<x, y> = PolynomialRing(QQ, 2);
- [ ] mais quand on declare comme ça x = var('x') y = var('y') le % marche plus
- [ ] le % il marche quand on déclare R.<x, y> = PolynomialRing(QQ, 2);  comme ça
- [ ] mais quand tu déclares comme ça le leading coeff fonctionne plus

```
def Euclide_polynome(A,B):
  S = A
  T = B
  while(T!=0):
    R = S % T
    S = T
    T = R
  return S
```