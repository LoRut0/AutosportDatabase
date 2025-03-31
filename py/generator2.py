from random import *
import os

f = open('quali.txt')
ans = []
for i in f:
    i = i[1:-3].split(', ')
    if len(i) > 1:
        i[0] = 1;
        i[1] = randint(95000, 125000)
        ans.append((int(i[0]), int(i[1]), int(i[2]), int(i[3]), int(i[4]), int(i[5]), int(i[6])))
for i in range(len(ans)):
    print(ans[i], ',', sep='')
os.system("pause")