import pandas as pd
import numpy as np

data_train = pd.read_csv('train.csv', keep_default_na = True)

#Make every entry uppercase
data_train = data_train.apply(lambda x: x.astype(str).str.upper())

#Split up the cpu column
new_cpu = data_train['cpu'].str.split(' ', n=1, expand=True)
data_train['cpu_brand'] = new_cpu[0]
data_train['cpu_type_name'] = new_cpu[1]

#Split up the gpu column
new_gpu = data_train['gpu'].str.split(' ', n=1, expand=True)
data_train['gpu_brand'] = new_gpu[0]
data_train['gpu_type'] = new_gpu[1]

#Extracting only the os details 
#Heb hier voor makkelijkste oplossing gekozen voor deze dataset; niet echt veralgemeenbaar maar werkt voor deze dataset
length_data_frame = len(data_train['os_details'])
new_os = list()
for i in range(0,length_data_frame):
    if data_train['os_details'][i][0] == 'W':
        new_os.append(data_train['os_details'][i][8:])
    elif data_train['os_details'][i][0] == 'C':
        new_os.append(data_train['os_details'][i][0:])
    elif data_train['os_details'][i][0] == 'O':
        new_os.append(data_train['os_details'][i][5:])
    elif data_train['os_details'][i][0] == 'M':
        new_os.append(data_train['os_details'][i][6:])
    elif data_train['os_details'][i][0] == 'A':
        new_os.append(data_train['os_details'][i][8:])
    else:
        new_os.append(data_train['os_details'][i][0:])
        
data_train['os_details_2'] = new_os


#Extracting cpu-details; moet ik nog verder naar kijken
"""data_train.apply(lambda x: x['cpu_details'].split(' ')[x['cpu_details'].split(' ').index('GHZ')-2].split('-')[1] \
       if '-' in x['cpu_details'].split(' ')[x['cpu_details'].split(' ').index('GHZ')-2] \
       else x['cpu_details'].split(' ')[x['cpu_details'].split(' ').index('GHZ')-2],axis=1)"""

cpu_details_2 = list()
for i in range(0, length_data_frame):
    if data_train['cpu_details'][i] != 'NAN' and 'GHZ' in data_train['cpu_details'][i].split(' '):
        if '-' in data_train['cpu_details'][i].split(' ')[data_train['cpu_details'][i].split(' ').index('GHZ')-2] :
            cpu_details_2.append(data_train['cpu_details'][i].split(' ')[data_train['cpu_details'][i].split(' ').index('GHZ')-2].split('-')[1])
        else:
            cpu_details_2.append(data_train['cpu_details'][i].split(' ')[data_train['cpu_details'][i].split(' ').index('GHZ')-2])
    else:
        cpu_details_2.append('NAN')

data_train['cpu_details_2'] = cpu_details_2
data_train.to_csv("/Users/bjrn/Documents/GitHub/adana123/datafile2.csv")
