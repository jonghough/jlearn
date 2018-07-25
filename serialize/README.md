# Serialization of Machine Learning Models

## Serialize

Since models can take a long time to train, it si beneficial to
be able to save their current state (trained or partially trained),
and be able to return to the model at a later time, to continue using it.

To save models - which are likely to be MLP Classifiers, Regressors and NNPipelines - the `Serializer` class
can be used to serialize the objects (plural, since most models contain an assortment of objects), which can then be
saved to disk as a text file (TODO - compress the file).

*WARNING* For large models, e.g. a large ConvNet, the size of the serialized
data can be 100+ MB in size. 

### Example

```j
myModel=: ... NB. create a NNPipeline, for example
NB. ... training...

NB. I want to save my model and come back another day.
s=: '' conew 'Serializer'
smodel=: serialize__s myModel
smodel 1!:2 < '/absolute/path/to/save/location/MY_MODEL.txt'
```

Later on, to recreate the object(s) from **MY_MODEL.txt**

```j
s=: '' conew 'Serializer'
smodel=: 1 !:1 < '/absolute/path/to/save/location/MY_MODEL.txt'
copyOfMyModel=: deserialize__s smodel
```
In the above example, `myModel` and `copyOfMyModel` will have identical
behaviour.