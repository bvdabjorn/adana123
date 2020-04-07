import pandas as pd
import numpy as np
from fuzzywuzzy import fuzz
import regex as re
    
def make_uppercase(dataset):
    #Make a datafram uppercase
    return dataset.apply(lambda x: x.astype(str).str.upper())
    

def split_cpu(dataset):
    ## Split up the cpu column
    # Create 2 new columns: CPU Brand and CPU Type
    new_cpu = dataset['cpu'].str.split(' ', n=1, expand=True)
    dataset['cpu_brand'] = new_cpu[0]
    dataset['cpu_type_name'] = new_cpu[1]
    return dataset
    

def split_gpu(dataset):
    ## Split up the gpu column
    # Create 2 new columns: GPU Brand and GPU type
    new_gpu = dataset['gpu'].str.split(' ', n=1, expand=True)
    dataset['gpu_brand'] = new_gpu[0]
    dataset['gpu_type'] = new_gpu[1]
    return dataset


def extract_os_details(dataset):
    #Extracting only the os details
    length = len(dataset['os_details'])
    new_os = list()
    for i in range(0,length):
        if dataset['os_details'][i][0] == 'W':
            new_os.append(dataset['os_details'][i][8:])
        elif dataset['os_details'][i][0] == 'C':
            new_os.append(dataset['os_details'][i][0:])
        elif dataset['os_details'][i][0] == 'O':
            new_os.append(dataset['os_details'][i][5:])
        elif dataset['os_details'][i][0] == 'M':
            new_os.append(dataset['os_details'][i][6:])
        elif dataset['os_details'][i][0] == 'A':
            new_os.append(dataset['os_details'][i][8:])
        else:
            new_os.append(dataset['os_details'][i][0:])
    
    dataset['os_details_2'] = new_os
    return dataset
    

def extract_cpu_type_name(dataset):
    #Get cpu number in extra column
    length = len(dataset['cpu_details'])
    cpu_details_2 = list()
    for i in range(0, length):
        if pd.notna(dataset['cpu_details'][i]) and 'GHZ' in dataset['cpu_details'][i].split(' '):
            if '-' in dataset['cpu_details'][i].split(' ')[dataset['cpu_details'][i].split(' ').index('GHZ')-2] :
                cpu_details_2.append(dataset['cpu_details'][i].split(' ')[dataset['cpu_details'][i].split(' ').index('GHZ')-2].split('-')[1])
            else:
                cpu_details_2.append(dataset['cpu_details'][i].split(' ')[dataset['cpu_details'][i].split(' ').index('GHZ')-2])
        else:
            cpu_details_2.append(np.nan)
            
    dataset['cpu_details_2'] = cpu_details_2
    return dataset
    
def extract_cpu_ghz(dataset):
    #Get cpu GHZ in extra column
    length = len(dataset['cpu_details'])        
    cpu_GHZ = list()
    for i in range(0, length):
        if 'GHZ' in dataset['cpu_details'][i].split(' '):
            GHZ = dataset['cpu_details'][i].split(' ')[dataset['cpu_details'][i].split(' ').index('GHZ')-1]
            cpu_GHZ.append(GHZ)
        else:
            cpu_GHZ.append(np.NaN)
    
    dataset['cpu_GHZ'] = cpu_GHZ
    return dataset

def get_cpu_core(dataset):
    length = len(dataset['cpu_details'])
    dataset['cpu_core'] = np.NaN
    for i in range(0, length):
        for k in dataset['cpu_details'][i].split(' '):
            if re.search('.+-CORE', k):
                k = k.replace('(','')
                k = k.replace(')','')
                dataset['cpu_core'][i] = k
            else:
                continue
    
    return dataset
    
def get_threading(dataset):
    length = len(dataset['cpu_details'])
    dataset['threading'] = np.NaN
    for i in range(0, length):
        cpu = dataset['cpu_details'][i]
        cpu = cpu.replace('(','')
        cpu = cpu.replace(')','')
        if 'MULTI-THREADING' in cpu:
            dataset['threading'][i] = 1
        elif 'HYPER-THREADING' in cpu:
            dataset['threading'][i] = 1
        else:
            dataset['threading'][i] = 0
        
    return dataset

def link_cpu_to_benchmark_score(dataset, benchmarkset):
    # Linking cpu benchmark results to dataframe
    dataset['cpu_benchmark'] = np.NaN
    for i in range(len(dataset['cpu_details_2'])):
        for j in range(len(benchmarkset['cpu name'])):
            if str(dataset['cpu_details_2'][i]) in str(benchmarkset['cpu name'][j]):
                dataset['cpu_benchmark'][i] = benchmarkset['passmark cpu score'][j]
       
    return dataset

def link_gpu_to_benchmark_score(dataset, benchmarkset):
    # Linking gpu benchmark results to dataframe
    dataset['gpu_benchmark'] = np.NaN
    for i in range(len(dataset['gpu_type'])):
        for j in range(len(benchmarkset['gpu name'])):
            if str(dataset['gpu_type'][i]) == str(benchmarkset['gpu name'][j]):
                dataset['gpu_benchmark'][i] = benchmarkset['gpu passmark score'][j]
            else:
                continue
        if pd.isna(dataset['gpu_benchmark'][i]):
            for k in range(len(benchmarkset['gpu name'])):
                if fuzz.token_set_ratio(benchmarkset['gpu name'][k], dataset['gpu_type'][i]) > 90:
                    dataset['gpu_benchmark'][i] = benchmarkset['gpu passmark score'][k]
                else:
                    continue
                
    return dataset
            
def validateString(s):
    letter_flag = False
    number_flag = False
    for i in s:
        if i.isalpha():
            letter_flag = True
        if i.isdigit():
            number_flag = True
    return letter_flag, number_flag

def get_name(dataset):      
    length = len(dataset['base_name'])
    dataset['pc_name'] = np.NaN
    for i in range(0,length):
        string = ''
        for k in dataset['base_name'][i].split(' '):
            k = k.replace('-',' ')
            letter_flag, number_flag = validateString(k)
            if (letter_flag == True and number_flag == True) or (letter_flag == False and number_flag == True):
                break
            else:
                string = string + ' ' + k
        dataset['pc_name'][i] = string[1:]
                
    return dataset
        

    
def main():
    
    #Load the 3 necessary datafiles 
    data_train = pd.read_csv('/Users/bjrn/Documents/GitHub/adana123/train.csv', keep_default_na=True)
    cpu_data = pd.read_csv('/Users/bjrn/Documents/GitHub/adana123/CPU_Benchmark.csv', sep=';')
    gpu_data = pd.read_csv('/Users/bjrn/Documents/GitHub/adana123/GPU_Benchmark.csv', sep=';')
    
    
    #Preprocessing steps
    data_train = make_uppercase(data_train)
    cpu_data = make_uppercase(cpu_data)
    gpu_data = make_uppercase(gpu_data)
    data_train = split_cpu(data_train)
    data_train = split_gpu(data_train)
    data_train = extract_os_details(data_train)
    data_train = extract_cpu_type_name(data_train)
    data_train = extract_cpu_ghz(data_train)
    data_train = link_cpu_to_benchmark_score(data_train, cpu_data)
    data_train = link_gpu_to_benchmark_score(data_train, gpu_data)
    data_train = get_cpu_core(data_train)
    data_train = get_threading(data_train)
    data_train = get_name(data_train)
    
    data_train.to_csv('/Users/bjrn/Documents/GitHub/adana123/datafile2.csv')
    
main()