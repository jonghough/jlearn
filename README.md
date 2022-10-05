``` 
        _____   _____     ________       _       _______     ____  _____  
       |_   _| |_   _|   |_   __  |     / \     |_   __ \   |_   \|_   _| 
         | |     | |       | |_ \_|    / _ \      | |__) |    |   \ | |   
     _   | |     | |   _   |  _| _    / ___ \     |  __ /     | |\ \| |   
    | |__' | _  _| |__/ | _| |__/ | _/ /   \ \_  _| |  \ \_  _| |_\   |_  
    `.____.'(_)|________||________||____| |____||____| |___||_____|\____| 
                                                                      
```



![brain](/jlearn.gif)

# Machine Learning with J. 
WIP Machine learning library, written in J. Various algorithm implementations, including MLPClassifiers, MLPRegressors, Mixture Models, K-Means, KNN, RBF-Network, Self-organizing Maps.

![som_clusters](/iris_som_all.png)

# Implemented Algorithms 

| Algorithm                      | Classification | Regression | Clustering       | Pattern Matching / Completion | Other  | Notes                                                             |
|:-------------------------------|:--------------:|:----------:|:----------------:|:-----------------------------:|:------:|:------------------------------------------------------------------|
| Multilayer Perceptron          | o              | o          | n/a              | n/a                           |        | Batch SGD with choice of gradient optimizers.                     |
| Gaussian Processes             | x              | o          | n/a              | n/a                           |        |                                                                   |
| RBF Network                    | o              | o          | n/a              | n/a                           |        |                                                                   |
| Decision Tree                  | o              | x          | n/a              | n/a                           |        | Regressor needs implementing.                                     |
| AdaBoost Ensemble              | o              | x          | n/a              | n/a                           |        |                                                                   |
| Gaussian Mixtures              | n/a            | n/a        | o                | n/a                           |        |                                                                   |
| K-means / K-medians            | n/a            | n/a        | o                | n/a                           |        |                                                                   |
| Hierarchical Clustering        | n/a            | n/a        | o                | n/a                           |        | Agglomerative clustering                                          |
| K-nearest Neighbours           | n/a            | n/a        | o                | n/a                           |        |                                                                   |
| DBSCAN                         | n/a            | n/a        | o                | n/a                           |        |                                                                   |
| Kd-tree                        | o              | x          | o                | n/a                           |        |                                                                   |
| Self-Organizing Maps           | n/a            | n/a        | n/a              | o                             |        |                                                                   |
| Hopfield Networks              | n/a            | x          | n/a              | o                             |        |                                                                   |
| Restricted Boltzmann Machines  | o              | n/a        | n/a              | o                             |        | Partial implementation.                                           |
| Convolutional Neural Networks  | o              | n/a        | n/a              | n/a                           |        | Experimental. 2D convolutions implemented.                        |
| Recurrent Neural Networks      | o              | x          | n/a              | n/a                           |        | Experimental. LSTMs implemented.                                  |
| PCA / KPCA                     | n/a            | n/a        | n/a              | n/a                           | o      | Dimensionality reduction.                                         |                                        |
| Genetic Algorithm Solver       | n/a            | n/a        | n/a              | n/a                           | o      | Optimization.
| Symbolic Regression Solver     | n/a            | n/a        | n/a              | n/a                           | o      | Function estimation.


# Other features

## Serialization
Models can be serialized to text files, with a mixture of text and binary packing. The size of the serialized file depends on the size of the model, but
will probably range from 10 MB and upwards for NN models (including convnets and rec-nets).