import perceptron

import bisect 
import numpy as np
import random as rd
import math
import seaborn as sns
sns.set(style="darkgrid")
import numpy as np
from sklearn.datasets import make_blobs
import matplotlib.pylab as plt

from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import

import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import numpy as np


def dist(i,x):
    return math.sqrt(np.sum(np.array([(x[j]-i[j])**2 for j in range(len(i))])))
def NearestNeighbor(x,X,y):
    (NN,d_min) = 0,1000000000
    for i in range(len(X)):
        d = dist(X[i],x)
        if(d<d_min):
            NN=i
            d_min = d
    return y[NN]
def split(X,y,per = 0.8):
    Xtr,ytr,Xte,yte = [],[],[],[]
    for i in range(len(y)):
        if(rd.random() < per):
            Xtr.append(X[i,:])
            ytr.append(y[i])
        else:
            Xte.append(X[i,:])
            yte.append(y[i])
    return np.array(Xtr),np.array(ytr),np.array(Xte),np.array(yte)


def KNearestNeighborNoW(x,X,y,k):
    # compute the k NN for initialisation
    vals=[dist(X[i],x) for i in range(k+1)]
    LNN = np.sort(vals)
    index = np.argsort(vals)
    # index will keep the indexes
    # LNN will keep the data
    for xi in range(k+1,len(X)):
        # compute distance to next int in data
        d = dist(X[xi],x)
        # if the distance is lower than the furthest element
        if(d<LNN[-1]):
            # remove last element
            LNN = LNN[:-1] 
            index = index[:-1]
            to_i = LNN.searchsorted(d)
            # insert newest element
            LNN = np.insert(LNN, to_i,d) 
            index = np.insert(index,to_i,xi)
            
    return np.median(y[index])

def vote(y,w):
    prod = list(np.unique(y, return_counts=False))
    valu = [0 for i in range(len(prod))]

    for i in range(len(y)):
        valu[prod.index(y[i])]+=w[i]
    percent = valu/np.sum(valu)
    return prod[np.argmax(percent)]

def KNearestNeighbor(x,X,y,k,sigma):
    vals=[dist(X[i],x) for i in range(k+1)]
    LNN = np.sort(vals)
    index = np.argsort(vals)
    for xi in range(k+1,len(X)):
        d = dist(X[xi],x)
        if(d<LNN[-1]):
            LNN = LNN[:-1]
            index = index[:-1]
            to_i = LNN.searchsorted(d)
            LNN=np.insert(LNN, to_i,d) 
            index = np.insert(index,to_i,xi)
        w = [math.exp(-LNN[i]/sigma**2) for i in range(len(LNN))]
    return vote(y[index],w)

def Kpred(data,X,y,k,sigma):
    res =[]
    for i in data:
        res.append(round(KNearestNeighbor(i,X,y,k,sigma)))
    return np.array(res)
    
def KpredNoW(data,X,y,k):
    res =[]
    for i in data:
        res.append(round(KNearestNeighborNoW(i,X,y,k)))
    return np.array(res)


def predict(data,X,y):
    res =[]
    for i in data:
        res.append(NearestNeighbor(i,X,y))
    return np.array(res)


def true_positive(res,y):
    return (res==y).sum()
def false_negative(res,y):
    return (res!=y).sum()

def true_positive_perceptron(res,y,k):
    c=0
    for i in range(len(res)):
        if(y[i]==1 and res[i]==k): c+=1
    return c
def false_negative_perceptron(res,y,k):
    c=0
    for i in range(len(res)):
        if(y[i]==-1 and res[i]==k): c+=1
    return c


X, y = make_blobs(n_samples=100, n_features=2, centers=5, cluster_std=4.0, center_box=(-10.0, 10.0))
h = .4 # Precision de la grille
x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
xx, yy = np.meshgrid(np.arange(x_min, x_max, h),np.arange(y_min, y_max, h)) 
data = np.c_[xx.ravel(), yy.ravel()]
# Dans le format de votre classifier

TP_perceptron = []
FP_perceptron = []
TP_KNNWeight = []
FP_KNNWeight = []
TP_KNN = []
FP_KNN = []
TP_NN = []
FP_NN = []
Xtr,ytr,Xte,yte = split(X,y)

for k in range(len(np.unique(yte, return_counts=False))):
    labels_k = perceptron.two_classes(ytr, k)
    weights, errors = perceptron.train(Xtr, labels_k, with_errors=True)
    pred = np.array([ perceptron.predict(weights,x)  for x in Xte ])
    TP_perceptron.append(true_positive_perceptron(pred,yte,k))
    FP_perceptron.append(false_negative_perceptron(pred,yte,k))
    # For each class we have a TP and FP


S = [0.1, 0.2, 0.5, 1, 2, 5]
K = [2, 3, 4, 5, 10, 15]
z1 = predict(Xte,Xtr,ytr) 

TP_NN.append(true_positive(z1,yte))
FP_NN.append(false_negative(z1,yte))
s = 0.1
k = 10

Z1 = []
Z2 =[]
Z3 = []
Z4 = []

for k in K:
    TP_KNNWeight = []
    FP_KNNWeight = []
    TP_KNN = []
    FP_KNN = []
    for sigma in S: 
        z2 = KpredNoW(Xte,Xtr,ytr,k) 
        z3 = Kpred(Xte,Xtr,ytr,k,sigma) 
        TP_KNNWeight.append(true_positive(z2,yte))
        FP_KNNWeight.append(false_negative(z2,yte))
        TP_KNN.append(true_positive(z3,yte))
        FP_KNN.append(false_negative(z3,yte))
    Z1.append(TP_KNNWeight)
    Z2.append(FP_KNNWeight)
    Z3.append(TP_KNN)
    Z4.append(FP_KNN)       


print(Z1)
print(Z2)
print(Z3)
print(Z4)
for i in range(len(K)):
    plt.figure()
    plt.plot(S,Z1[i],label="TP KNN no weight")
    plt.plot(S,Z3[i],label="TP KNN weight")
    plt.plot(S,Z2[i],'--',label="FP KNN no weight",color='r')
    plt.plot(S,Z4[i],'--',label="FP KNN weight",color='b')
    plt.legend()
    plt.xlabel("sigma")
    plt.ylabel("TP")
    plt.title("k = "+str(K[i]))
    plt.show()
        


