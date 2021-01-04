import matplotlib.animation as animation
from matplotlib.animation import FuncAnimation
from sklearn import cluster, datasets, mixture
import numpy as np
import matplotlib.pyplot as plt
import os

def weight_update(w,b,x,y):
    # Fonction to update the wheights given an exemple and a label
    for i in range(len(w)):
        w[i] += epsilon*(y-np.sum(x*w)+b)*x[i]

def E(X,y,w,b):
    e = 0
    for i in range(len(X)):
        e+= (1/2)*(y[i] - np.sum(X[i]*w)+b)**2
    return e/len(y)

def train(X,y,epsilon):
    N = 400
    n = np.shape(X)[1]
    print("weight size : {}".format(n))
    w = -0.001+np.zeros(n)
    biais = 1
    B = np.zeros(N)
    Er = np.zeros(N+1)
    W = np.zeros((N,n))
    Er[0] = E(X,y,w,biais)
    k = 0
    if("weights.np" in os.listdir()):
        with open("weights.np",'rb') as f:
            w = np.load(f)
            biais = np.load(f)
            B = np.load(f)
            W = np.load(f)
            k = np.load(f)
    while(k<N):
        for i in range(len(y)):
            print("epoch n°{}, sample n°{}/{}".format(k,i,len(y)),end='\r')
            new_bias = epsilon * (y[i]-np.sum(X[i]*w)+biais)
            weight_update(w,biais,X[i],y[i])
            biais = new_bias
        B[k] = biais
        W[k] = w
        k+=1
        Er[k] = E(X,y,w,biais)
        print("\nloss = {}".format(Er[k]),end='\n')
        if(k%10==0):
            print("saving weights to weights.")
            with open("weights.np",'wb') as f:
                np.save(f,w)
                np.save(f,biais)
                np.save(f,B)
                np.save(f,W)
                np.save(f,k)
            epsilon /=10
    plt.figure(1)
    plt.plot(Er)
    plt.show()
    return w,biais,B,W

def predict(x,w,b):
    return np.sum(x*w)+biais

epsilon=0.000001




dtrain = np.loadtxt("zip.train")
dtest  = np.loadtxt("zip.test")
X = dtrain[:,1:]
y = dtrain[:,0]
weight,biais,B,W = train(X,y,epsilon)
X = dtest[:,1:]
y = dtest[:,0]
dy = [predict(i,weight,biais) for i in X]
prec = [y[i] - dy[i] for i in range(len(y))]
print(prec)
plt.plot([i for i in range(len(y))],prec)
