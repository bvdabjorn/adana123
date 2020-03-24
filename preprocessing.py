import pandas as pd
import numpy as np
from fuzzywuzzy import fuzz

## Edit Print options
desired_width = 500
pd.set_option('display.width', desired_width)
pd.set_option('display.max_columns', 30)


data_train = pd.read_csv('train.csv', keep_default_na = True)
# Load data
data_train = pd.read_csv('/Users/bjrn/Documents/GitHub/adana123/train.csv', keep_default_na=True)
cpu_data = pd.read_csv('/Users/bjrn/Documents/GitHub/adana123/CPU_Benchmark.csv', sep=';')
gpu_data = pd.read_csv('/Users/bjrn/Documents/GitHub/adana123/GPU_Benchmark.csv', sep=';')

#Make every entry uppercase
data_train = data_train.apply(lambda x: x.astype(str).str.upper())
cpu_data = cpu_data.apply(lambda x: x.astype(str).str.upper())
gpu_data = gpu_data.apply(lambda x: x.astype(str).str.upper())

## Split up the cpu column
# Create 2 new columns: CPU Brand and CPU Type
new_cpu = data_train['cpu'].str.split(' ', n=1, expand=True)
data_train['cpu_brand'] = new_cpu[0]
data_train['cpu_type_name'] = new_cpu[1]

## Split up the gpu column
# Create 2 new columns: GPU Brand and GPU type
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



## Extracting cpu-details; moet ik nog verder naar kijken
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

# Linking cpu benchmark results to dataframe
data_train['cpu_benchmark'] = 'NAN'
for i in range(len(data_train['cpu_details_2'])):
    for j in range(len(cpu_data['cpu name'])):
        if fuzz.ratio(data_train['cpu_details_2'][i], cpu_data['cpu name'][j]) > 95:
            data_train['cpu_benchmark'][i] = cpu_data['passmark cpu score'][j]

 # Linking gpu benchmark results to dataframe
data_train['gpu_benchmark'] = 'NAN'
for i in range(len(data_train['gpu_type'])):
    for j in range(len(gpu_data['gpu name'])):
        if fuzz.ratio(data_train['gpu_type'][i], gpu_data['gpu name'][j]) > 95:
            data_train['gpu_benchmark'][i] = gpu_data['gpu passmark score'][j]


## Difference between Max and Min prices:
diff_price = list()
for i in range(0,length_data_frame):
    diff_price.append(float(data_train['max_price'][i]) - float(data_train['min_price'][i]))

data_train['diff_price'] = diff_price
# data_train.to_csv("/Users/bjrn/Documents/GitHub/adana123/datafile2.csv")
data_train.to_csv("/Users/Simon/Documents/GitHub/adana123/datafile2.csv")

# print(data_train)

