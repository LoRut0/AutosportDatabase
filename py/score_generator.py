#from random import *
f = open('full_lap_data.csv')

QUALI_SCORE = [5, 3, 1, 0]
RACE_SCORE = [15, 10, 8, 7, 5, 4, 3, 2, 1, 0]

f.readline()
answer_race = []
answer_quali = []
output = []
last_type_of_lap = False
position = 0
for i in f:
    i = i.split(',')
    if len(i) > 1:

        pilot_id, stage_id, total_laps  = int(i[0]), int(i[1]), int(i[3][1:-1])
        type_of_lap = False if i[2] == '"Qualification"' else True #Quali = 0; Race = 1

        position = position + 1 if last_type_of_lap == type_of_lap else 1
        last_type_of_lap = type_of_lap

        if type_of_lap == 0:
            answer_quali.append((position, stage_id, int(type_of_lap), pilot_id))
        else:
            answer_race.append((position, stage_id, int(type_of_lap), pilot_id))
"""
for i in range(len(answer_quali)):
    print(answer_quali[i], ',', sep='')
for i in range(len(answer_race)):
    print(answer_race[i], ',', sep='')
"""
print(len(answer_quali), len(answer_race))
for i in range(len(answer_quali)):
    temp = answer_quali[i]
    quali_score = 0
    position = temp[0]
    if position < 4:
        quali_score = QUALI_SCORE[position - 1]
    stage_id = temp[1]
    pilot_id = temp[3]
    output.append([quali_score, 0, pilot_id, stage_id])

for i in range(len(answer_race)):
    temp = answer_race[i]
    race_score = 0
    position = temp[0]
    if position < 10:
        race_score = RACE_SCORE[position - 1]
    stage_id = temp[1]
    pilot_id = temp[3]
    for k in range(len(output)):
        if output[k][2] == pilot_id and output[k][3] == stage_id:
            output[k][1] = race_score

output_tuple = []

for i in output:
    output_tuple.append((i[0], i[1], i[2], i[3]))

for i in range(len(output_tuple)):
    print(output_tuple[i], ',', sep='')
