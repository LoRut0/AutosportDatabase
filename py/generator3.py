from random import *

f = open('lap_data.txt')
penalties = ["Срез трассы", "Превышение скорости на пит-лейне", "Пересечение разметки на выезде из пит-лейна", "Столкновение", "Фальстарт", "Игнорирование флагов"]
time_of_penalty = [4000, 5000, 3000, 8000, 5000, 5000]
ans = []
cnt = 0
for i in f:
    i = i[1:-3].split(', ')
    if len(i) > 1 and randint(0, 29) == 0:
        cnt += 1
        random = randint(0, 5)
        lap, lap_flag, pilots_id, stages_id = int(i[2]), int(i[0]), int(i[5]), int(i[6])
        ans.append((cnt, time_of_penalty[random], penalties[random], lap, lap_flag, pilots_id, stages_id))
for i in range(len(ans)):
    print(ans[i], ',', sep='')

        
