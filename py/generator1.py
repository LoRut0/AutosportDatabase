from random import *
f = open('26.10.1.txt')
d = []
ans = []
laps = [5, 5, 10, 8, 6, 5]
cnt = 0
for i in f:
    i = i[1:-3].split(', ')
    if len(i) > 1:
        a, b = int(i[2]), int(i[3])
        tire = randint(1, 11)
        cnt += 1
        #print(cnt)
        for i in range(1, laps[b-1]+1):
            pit = 0
            time = randint(95000, 125000)
            val = randint(0, 9)
            if val == 0:
                time += randint(30000, 40000)
                pit = 1
            ans.append((1, time, i, pit, tire, a, b))
for i in range(len(ans)):
    print(ans[i], ',', sep='')
