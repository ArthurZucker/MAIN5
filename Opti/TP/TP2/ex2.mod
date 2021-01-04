#--TODO: 
#--   . adapter les noms pour refleter une formulation perso ... 
#--   . ajouter dans enonce : subtilite ampl pour les ensembles i comme valeur 
#-- et [i] comme indice 
#---
#--
#-- Methode generation de colonne
#-- 
#--  Exemple: decoupe industrielle 
#-- 

# ----------------------------------------
# -- Probleme principal (beaucoup de colonnes ...)
# ---------------------------------------------

param taille_rouleau > 0;    # taille d'un rouleau 

set LongDEMANDEES;                # Longueurs demandees 

param DEMANDE {LongDEMANDEES} > 0; # liste des demandes de chaque longueur 

param nbrMotifs integer >= 0; 

set MOTIFS := 1 .. nbrMotifs; 

param Dmd{LongDEMANDEES,MOTIFS} integer >= 0;
   check {j in MOTIFS}: 
      sum {i in LongDEMANDEES} i * Dmd[i,j] <= taille_rouleau;

                            # defn of patterns: nbr[i,j] = number
                            # of rolls of width i in pattern j

var x{MOTIFS} integer >= 0;   # rolls cut using each pattern

minimize nbrRouleaux:                   # minimize total raw rolls cut
   sum {j in MOTIFS} x[j];   

subject to ContDmd {i in LongDEMANDEES}:
   sum {j in MOTIFS} Dmd[i,j] * x[j] >= DEMANDE[i];

                                   # for each width, total
                                   # rolls cut meets total orders

# ----------------------------------------
# -- Sous-probleme: generer les points extremes ...
# --------------------------------------------------

param prix {LongDEMANDEES} default 0.0;

var y {LongDEMANDEES} integer >= 0;

minimize CoutReduit:  
   1 - sum {i in LongDEMANDEES} prix[i] * y[i];

subject to LongLimite:  
   sum {i in LongDEMANDEES} i * y[i] <= taille_rouleau;