import pandas as pd
import numpy as np

data_train = pd.read_csv('train.csv')

#Make every entry uppercase
data_train = data_train.apply(lambda x: x.astype(str).str.upper())

#Split up the cpu column
new_cpu = data_train['cpu'].str.split(' ', n=1, expand=True)
data_train['cpu_brand'] = new_cpu[0]
data_train['cpu_type_name'] = new_cpu[1]

new_gpu = data_train['gpu'].str.split(' ', n=1, expand=True)
data_train['gpu_brand'] = new_gpu[0]
data_train['gpu_type'] = new_gpu[1]

length_data_frame = len(data_train['os_details'])
for i in range(0,length_data_frame+1):
    if data_train['os_details'][i][0] == 'W':
        data_train['os_details'][i].str.split(' ', n=1, expand=True)