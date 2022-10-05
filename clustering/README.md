# K-means example
Example using K-means clustering algorithm for image segmentation.
(also, see Pattern Recognition and Machine Learning, Cristopher M. Bishop)

```
load 'viewmat'
load 'graphics/jpeg'

image=: readjpeg jpath '/path/to/my/image.jpg'
shape=: $ image
amask=: dfh 'FF000000'
rmask=: dfh 'FF0000'
gmask=: dfh 'FF00'
bmask=: dfh 'FF'
max=: >./,image
norm =: ] % >./
shift=: (33 b.)
NB. separate colours
b=: ,256%~ image AND bmask
g=: ,(2^16)%~ 8 shift (_8 shift image) AND bmask
r=: ,(2^24)%~ 16 shift (_16 shift image) AND bmask
X=:|:(r),.(g),.(b)
km =: (X;'Euclidean';3;'uniform') conew 'KMeans' NB. 3 colors
fit__km 100
viewrgb 256 256 $, (1 3 $ (2^16), (2^8), 1) (+/ .*) |: <. max * labels__km (+/ .*) means__km
```

## Results
Following images show an original image, the same image after applying k-means image segmentation with 3 colours, and 
the same for 6 colours.

![tigers](/clustering/tigers.png)

# Hierarchical Agglomerative Clustering
Using the 'HCluster' class it is possible to perofrm heirarchical clustering
on a dataset.

## Example
Perform Heirarchical clustering of the iris dataset to partition the set into
3 classes.
```j
hc=: (X;'euclidean';'average';3) conew 'HCluster'
fit__hc ''
{.Ks__hc
```

The variable `Ks__hc` contains the separate cluster classes for each datapoint, for each iteration
of clustering.  The head of this list is the smallest number of clusters, in this case 3. 
```j
 {.Ks__hc
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 50 50 50 50 50 50 50 57 50 50 57 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 57 50 50 50 50 57 50 50 50 ...
```
We can see how many datapoints are in each cluster.
```j
#/.~ {.Ks__hc
50 96 4


# DBSCAN

DBSCAN is a method for clustering with an unknown number of clusters. i.e. the number of clusters and the data points to be placed
in each cluster are decided by the *DBSCAN* algorithm.

## Example 1, random data
```j
X=: ? 100 2 $ 0
db=: (X;'Euclidean';0.3;5) conew 'DBSCAN'
fit__db ''
K=:(< X) ({~&.>) L__db  I.&.>@:<@:="_ 0 ~. L__db
plotClusters__db K
```
Note that `L__db` gives the cluster allocation per data point.

### Showing results
In the above example we can plot the results on a 2D cluster diagram.
First let's create a verb to plot the points
```j
load 'plot'
plotClusters=: 3 : 0
pd 'reset'
pd 'type marker'
for_i. i. # y do.
pd <"1|: > i{y
end.
pd 'show'
)
```
Then let's plot each data point with its corresponding cluster label.
```j
clusters=:(< X) ({~&.>) L__db  I.&.>@:<@:="_ 0 ~. L__db
plotClusters clusters
```

```