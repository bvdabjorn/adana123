## Assignment 2 - Advanced Analytics
import pandas as pd, numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)

missing_values = ["n/a", "na", "--","NAN"]
train = pd.read_csv('train.csv',na_values = missing_values)
ext_data = pd.read_csv('datafile2.csv',na_values = missing_values)

# print(ext_data.shape)
# ext_data.head()
print(ext_data.dtypes)

