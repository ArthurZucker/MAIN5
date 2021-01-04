import numpy as np
from matplotlib import pyplot

max_iter = 100
epsilon  = 1e-3

def F(weights, x):
    return np.dot(weights, x)

def two_classes(labels, label_of_interest):
    n = labels.shape[0]
    ones = np.ones(n)
    minus_ones = -np.ones(n)
    return np.select([labels == label_of_interest,
                      labels != label_of_interest],
                     [ones, minus_ones])

def update(weights, x, t):
    error    = (t - F(weights, x))
    weights += epsilon * error * x

def train1(data, labels):
    n = data.shape[0] # Nombre d'observations
    d = data.shape[1] # Dimension des observations (et donc taille du vecteur de poids)

    iter_count = 0
    weights    = np.zeros(d)
    while iter_count < max_iter:
        for i in range(n): # Boucle sur toutes les observations
            update(weights, data[i], labels[i])
        iter_count += 1

    return weights
    

def train2(data, labels):
    n = data.shape[0]
    d = data.shape[1]

    iter_count = 0
    weights    = np.zeros(d)

    error_old = 0.0
    error     = 1.0

    while iter_count < max_iter and abs(error - error_old) < 1e-3:
        error_old = error
        error     = 0.0 # Erreur globale

        for i in range(n):
            update(weights, data[i], labels[i])
            error += (labels[i] - F(weights, data[i]))**2 # Erreur sur une observation

        iter_count += 1

    return weights

def train3(data, labels):
    n = data.shape[0]
    d = data.shape[1]

    iter_count = 0
    weights    = np.zeros(d)

    errors    = [] # Liste des valeurs de l'erreur globale
    error_old = 0.0
    error     = 1.0

    while iter_count < max_iter and abs(error - error_old) > 1e-3:
        error_old = error
        error     = 0.0

        for i in range(n):
            update(weights, data[i], labels[i])
            error += (labels[i] - F(weights, data[i]))**2

        iter_count += 1
        errors.append(error) # Sauvegarde de l'erreur globale

    return weights, errors

def append_bias(data):
    n = data.shape[0]
    d = data.shape[1]

    ones = np.ones((n, 1)) # Colonne de 1 a rajouter
    data2 = np.concatenate([data, ones], axis=1) # Grace a axis=1, c'est une colonne
                                                 # que l'on rajoute

    return data2

def train(data, labels, with_errors=False):
    data2 = append_bias(data)
    if with_errors:
        return train3(data2, labels) # weights, errors
    else:
        return train2(data2, labels) # weights

def h(x):
    if x > 0:
        return 1
    else:
        return -1

def predict2(weights, x):
    return h(F(weights, x))

def predict(weights, x):
    ones = np.ones(1)
    x2 = np.concatenate([x, ones], axis=0)
    return predict2(weights, x2)
