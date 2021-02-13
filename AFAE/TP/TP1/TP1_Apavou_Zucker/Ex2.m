n = 3:42;
x = 1.333;
for i=1:length(n)
    a = poly(ones(1,n(i)));
    res1 = Horner    (a,x);     % Classic horner
    res2 = sHorner   (a,x);     % Thorical value
    res3 = CompHorner(a,x);     % Compensated Horner
    er1(i) = abs(res2-res1)/abs(res2);
    er2(i) = abs(res2-res3)/abs(res2);
    c(i) = condp(a,x);
    Ci(i) = c(i);
    %c(i) = abs((x+1)/(x-1))^i;
    cond1(i) = 2*n(i)*eps*c(i);
    cond2(i) = eps + 4*n(i)*n(i)*eps*eps*c(i);
end


cla
axis tight
figure(1)
loglog(c,er1,'b--d')
hold on;
loglog(c,er2,'r--x')
%xlim([c(1) c(i)])
hold on
loglog(c,cond1)
hold on;
loglog(c,cond2)
hold on
xline(1/eps)
xline(1/(eps*eps))
t = text(Ci(20),53290000,'\gamma_{n-1}cond');
t2 = text(Ci(20),1.28e-6,'u+\gamma_{n-1}^{2}cond','VerticalAlignment', 'top','HorizontalAlignment', 'left');
legend('schéma de Horner classique','schéma de Horner compensé')
xlabel("Conditionnement")
ylabel("Erreur direct relative ")
title("Représentation des courbes d'erreurs relatives en fonction du conditionnement pour l'évaluation d'Horner ")


n = 3:42;
for i=1:length(n)
   [p,C] = GenSum(n(i),c(i));
   Ci(i) = C;
   res5 = Sum(p);
   res6 = SCompSum(p);
   res7 = DCompSum(p);
   res8 = CompSum(p);
   exact = TSum(p);
   er5(i) = abs(exact-res5)/abs(exact);
   er6(i) = abs(exact-res6)/abs(exact);
   er7(i) = abs(exact-res7)/abs(exact);
   er8(i) = abs(exact-res8)/abs(exact);
   nu = (n(i)-1)*eps;
   gaman1 = nu/(1-nu);
   cond3(i) = gaman1*c(i);
   ScompCond(i) = 2*eps+eps*eps*n(i);
   DcompSumCond(i) = 2*eps;
   cond4(i) = eps + 4*n(i)*n(i)*eps*eps*c(i);
end

clc
axis tight
figure(2);
loglog(Ci,er5,'b--x');
hold on;
loglog(Ci,er6,'r--x');
hold on
loglog(Ci,er7,'g--x');
hold on
loglog(Ci,er8,'m--x');
hold on
xline(1/eps)
xline(1/(eps*eps))
hold on
loglog(c,cond3)
hold on;
loglog(c,cond4)
hold on;
loglog(c,DcompSumCond)
hold on;

t = text(Ci(20),1.28e-6,'u+\gamma_{n-1}^{2}cond','VerticalAlignment', 'top','HorizontalAlignment', 'left');
t2 = text(Ci(20),53290000,'\gamma_{n-1}cond');
t3 = text(Ci(30),100*eps,'2u');
legend('schéma de somme classique','schéma de Kahan','Schéma de Priest','schéma de la somme compensée ')
xlabel("Conditionnement")
ylabel("Erreur direct relative ")
title("Représentation des courbes d'erreurs relatives en fonction du conditionnement pour la sommation")
