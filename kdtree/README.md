# KD Tree

KD tree is a binary tree, used to partition k-dimensional space into smaller
regions useful for searching nearest neighbours of given datapoints.

# Example
Using digits.csv data. This is a dataset with 16 features and 10 labels, each
label representing a number from 0 to 9. 

```j
NB. column 16 is the label data.
data=: 16 readCSV_jLearnUtil_  '/path/to/digits/data.csv'

NB. split data into training, training labels, test, testlabels, respectively.
'X Y Z W'=: splitDataset_jLearnUtil_ data,(0.5;1)
NB. Y and W are essentially ignored for this example.

NB. create a kdtree on X, with a maximum depth of 8.
kdtree=: (X;8) conew 'KDTree'

NB. find nearest point to the first point in Z, our test set.
search__kdtree {.Z
┌────┬────────┐
│3110│0.290517│
└────┴────────┘
NB. The above indicates that the 3110th datapoint of X is closest, with a
NB. (euclidean) distance of 0.29.

NB. take a look
3110 { X
   0.46 1 0.21 0.85 0 0.6 0.24 0.42 0.68 0.44 1 0.49 0.76 0.25 0.58 0
{. Z
   0.36 1 0.22 0.96 0 0.69 0.06 0.42 0.68 0.42 1 0.51 0.64 0.26 0.5 0
NB. from observation, the two points look pretty close.

NB. We can check this by comparing distance of {.Z to each point in X.
I. (=<./) ({.Z) (+/&.:*:@:-)"1 _"_ 1 X
   3110



NB. closest points to the first 10 points of Z.
search__kdtree 10{.Z

┌────┬────────┐
│3110│0.290517│
├────┼────────┤
│1594│0.326956│
├────┼────────┤
│2041│0.236854│
├────┼────────┤
│200 │0.188944│
├────┼────────┤
│5002│0.177482│
├────┼────────┤
│710 │0.271477│
├────┼────────┤
│1535│0.257682│
├────┼────────┤
│2303│0.196469│
├────┼────────┤
│352 │0.139284│
├────┼────────┤
│4922│0.20664 │
└────┴────────┘


NB. note thaat X and Z were selected randomly bt slitDataset verb, so
NB. this example will have different results if run again.
```
