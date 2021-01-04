import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt
import math


sns.set_style("darkgrid")
data = pd.read_csv('./results.txt',sep=',',header=None)
data = pd.DataFrame(data)

names = ["Register noPin ","Global noPin ","Shared noPin ","Constant noPin "]
names2 = ["Register","Global","Shared","Constant", "Global __ldg()"]
t = [i for i in range(len(data[0]))]

for i in range(4):
	plt.semilogy(t, data[i],label=names[i])

data2 = pd.read_csv('./results_pin.txt',sep=',',header=None)
data2 = pd.DataFrame(data2)
t = [i for i in range(len(data2[0]))]
for i in range(5):
	plt.semilogy(t, data2[i],label=names2[i])
plt.title('Evolution du temps de calcul en fonction de la taille du vecteur x, représentation en semilogy')
plt.xlabel("N la taille de x")
plt.ylabel("Temps de calcul en ms")
plt.axis('tight')
plt.grid(True)
plt.legend()
plt.show()
