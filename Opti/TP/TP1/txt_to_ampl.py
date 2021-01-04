import os
file_list = os.listdir("data")
for file in file_list:
    output = file.split('.')[0]+".dat"

    output = open(output,"w")
    output.write("data;\n\nparam N := ")

    print(file)
    with open('data/'+file,'r') as f:
        Lines = f.readlines()
        output.write(str(len(Lines)-1)+";\n\nparam: Arcs: Cost :=")
        for i in range(len(Lines)-1):
            Lines[i] = (' '.join(Lines[i].split())).split(" ")

            for nb in range(len(Lines[i])):
                if(int(Lines[i][nb])>9998):
                    pass
                else:
                    output.write(str(i+1)+" "+str(nb+1)+" "+str(Lines[i][nb])+'\n')
        output.write(";")
