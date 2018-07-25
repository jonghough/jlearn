# Plotting functions

J has an assortment of plotting functions for 2D and 3D plots/graphs.

## Example

Plotting the gaussian mixture model gaussian curves for the iris dataset.
```j
NB. assume we have the data, and perform the E-M algorithm to find gaussians.
g =: (input;3) conew 'GMM'
fit__g 100

NB. create 3 functions, one for each gaussian curve. 
NB. here we give the first two features of the iris dataset 
NB. the value 0.25 and 0.55, respectively, and draw a 3d plot
NB. of the last two variables.
func0=: 0&gaussian__g"1@:(0.25 0.55&,@:,) NB. first gaussian
func1=: 1&gaussian__g"1@:(0.25 0.55&,@:,) NB. second gaussian
func2=: 2&gaussian__g"1@:(0.25 0.55&,@:,) NB. third gaussian

X=: steps 0 1 50
X0=: ($ $ (%>./)@:,) ,/"1 func0"(0 0)/~X
X1=: ($ $ (%>./)@:,) ,/"1 func1"(0 0)/~X
X2=: ($ $ (%>./)@:,) ,/"1 func2"(0 0)/~X

NB. plot the data on a 3d Surface
pd 'reset'
pd 'title Iris dataset plot'
pd X;X;(X0+X1+X2)
pd 'type surface'
pd 'viewpoint 0.2 2 2'
pd 'show'
pd 'save jpg iris_test1'
```

We can see the plot

![gmmplot](/plot/img/iris_test1.jpg)