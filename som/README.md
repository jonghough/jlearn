# Self-Organizing Map

## Details
Self-organizing maps can be used for classification, data visualization, clustering. The
implemented algorithm is relatively fast.

## Example
Example using iris dataset.

```
irisData =: ... NB. get the iris data
som=: (X;(40 40);4;0.95;0.1) conew 'SOM'  NB. create SOM instance.
fit__som 2000 NB. fit the data, using 2000 iterations.

viewmat umatrix__som '' NB. view the u-matrix.
viewmat distanceTo__som {. irisData NB. visualize the distances from each pt to the first
datapoint fo the iris dataset.

100 kmCluster__som 4 NB. cluster the data into 4 clusters (100 iterations)
viewmat clusters__som NB. visualize the clusters.
```


### U-Matrix plot example
![umatrixplot](/som/som_umatrix.png)

### distance plot example
![distplot](/som/som_distance.png)

### Clustering plot, with 3 clusters, representing 3 classes of the iris dataset.
![clusterplot](/som/som_clusters.png)