import pandas as pd
import numpy as np
import math
import io

import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import pydotplus

from sklearn.tree import DecisionTreeRegressor, export_graphviz
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
from sklearn.tree import plot_tree
from sklearn.externals.six import StringIO

from IPython.display import SVG
from graphviz import Source
from IPython.display import display

## Edit Print options
desired_width = 500
pd.set_option('display.width', desired_width)
pd.set_option('display.max_columns', 30)


missing_values = ["n/a", "na", "--","NAN"," ","nan"]
data = pd.read_csv('datafile2.csv',na_values = missing_values)

## Removing missing values
data.dropna()

#just a temporary dataset to test the capabilities of the model
temp_data = data[['brand','screen_size','touchscreen','discrete_gpu','gpu','ram','ssd', 'detachable_keyboard','weight',
                      'min_price','max_price']]






## Seperating categorical - binary - numerical variables
X_cat = temp_data[['brand']] #,'gpu']]
# X_bin = temp_data[['touchscreen','discrete_gpu','detachable_keyboard']]
# X_num = temp_data[['screen_size','ram','ssd','weight']]

## Creating dummy variables:
X_cat_dummies = pd.get_dummies(X_cat, drop_first=True)

## Merging input data
# X = pd.concat([X_cat_dummies,X_bin,X_num], axis=1)
# X = pd.concat([X_cat_dummies,X_num], axis=1)
X = X_cat_dummies

## Defining output data
Y = temp_data[['min_price','max_price']]

## Splitting the dataset into train and test sets
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.33, random_state=42)

print(X_train)
Model1 = DecisionTreeRegressor(criterion="mae",max_depth=6)
Model1.fit(X_train,Y_train)

# mean_absolute_error(multioutput='uniform_average')


## Printing the decision tree
FEATURE_NAMES = X_train.columns[:]


# dot_data = export_graphviz(Model1,
#                                out_file=None,
#                                feature_names=FEATURE_NAMES,
#                                class_names=TARGET_NAMES,
#                                filled = True)
# graph = Source(dot_data)
#
# dot_data = io.StringIO()
# export_graphviz(Model1, out_file=dot_data, rounded=True, filled=True)
# filename = "tree.png"
# pydotplus.graph_from_dot_data(dot_data.getvalue()).write_png(filename)
# plt.figure(figsize=(300,100))
# img = mpimg.imread(filename)
# imgplot = plt.imshow(img)
# plt.show()


plt.figure(figsize=(120,50))
plot_tree(Model1, feature_names=FEATURE_NAMES, fontsize=11, rounded=True)
plt.show()