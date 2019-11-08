# Genetic Algorithm Solver

Solving problems usign a genetic algorithm approach.

### Example TSP problem


```j
NB. a population of 80 chromosomes, and 10 cities.
tsp =: (80;10) conew 'TSPObj'
solver=: (tsp;0.2;10;5;11;0;0) conew 'GASolver'
NB. find the minimzing routes after 1000 iterations.
]selected=: 1000 fit__solver chromosomes__tsp ''
┌───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────...
│0 1 2 3 4 5 6 7 9 8│5 6 7 8 9 2 1 0 4 3│0 1 2 9 7 6 5 4 3 8│2 7 6 9 8 1 0 3 4 5│1 0 3 2 8 5 4 6 7 9│5 6 4 1 0 3 2 7 9 8│9 2 7 6 5 4 3 8 0 1│5 4 3 2 9 7 8 1 0 6│9 8 0 3 4 1 2 7 6 5│9 2 7 8 5 6 4 3 0 1│9 8 0 4 5 7 2 1 3 6│7 0 6 9 5 8 2 1 4 3│1 0 6 8 5 4 9 7...
└───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────...
 
NB. see the cost...
cost__tsp selected
60.5908 384.901 402.975 517.341 531.96 594.016 616.074 626.522 637.171 662.538 1894.89 2722.31 2884.88 3438.15 3714.94 4129.37 4309.32 4328.26 4367.77 4799.73 6220.36 6234.13 6235.12 6243.93 6252.43 6259.25 6263.08 6266.2 6268.71 6269.09 6275.69 6278.34 62...

```

### Example Knapsack problem
¥This example is of a simplified 01-knapsack problem.
Suppose we have 30 items of varying weights (integer values between 0 and 100), 
which we can define as `w`, and a value, `v`. We want to find the optimal combination
of items that have a combined weight less than 500. By obitmal we mean the highest sum of `v`.

To solve this we can create a `KnapsackObj` instance, and create, 100 chromosomes, say,
and run the genetic algorithm. We should be able to find a good, though not necessarily optimal,
solution.

```j
NB. the weights. 30 objects of varying weights.
w=: 37 78 49 56 0 4 33 87 9 61 55 33 23 47 30 23 64 48 49 56 69 30 75 22 6 21 73 13 92 82
v=: 1 3 4 3 2 10 1 1 2 4 2 5 8 1 1 1 4 5 7 3 7 2 1 1 4 1 2 2 6 5 8 1 2 1 9 1 9 7
k=: (v;w;500;100) conew 'KnapsackObj'
solver=: (k;0.2;10;5;11;0;0) conew 'GASolver'
]selection=: 1000 fit__solver chromosomes__k ''
┌───────────────────────────────────────────────────────────┬───────────────────────────────────────────────────────────┬───────────────────────────────────────────────────────────┬───────────────────────────────────────────────────────────┬───────────────...
│1 0 1 0 0 1 0 0 1 0 0 1 1 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0 1 1│0 0 0 1 0 1 0 0 1 0 1 1 1 1 1 1 0 0 1 0 0 0 0 0 1 1 0 0 0 0│1 0 0 0 1 1 1 0 0 0 1 1 1 1 0 1 0 1 0 1 0 1 1 0 0 1 0 1 0 0│0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 1 1 0 1 0 1 1 0 1 1 0│1 0 0 0 1 1 1 0...
└───────────────────────────────────────────────────────────┴───────────────────────────────────────────────────────────┴───────────────────────────────────────────────────────────┴───────────────────────────────────────────────────────────┴───────────────...
 ```
The cost of each possible selection of items is the negative of the sum of the values of the items, if the 
weight sum is less than the limit. Otherwise it is infinite, meaning it is a failed solution.
We can see the costs, where there any solution that exceeds the desired amount, has infinite cost.
```j
cost__k selection
_48 _45 _45 _41 _39 _38 _36 _34 _33 _32 _32 _31 _23 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  ```
The best solution has the optimal discovered sum of 48, and the weight sum is recovered by
```j
+/ w{~ I. > {. selection
467
```

## Symbolic Regression

*Symbolic Regression* is s tool used to searcha limit space of mathematical
expressions to find a model approximating the solution to some problem. 

e.g.

I have some  input values:

0, 0.1, 0.2,0.3,...,0.9

and some output values:

1.3,_3.2,1.25,_0.5,...,2.05


The goal is to figure out a function (or combination of functions) that maps
the input to the output, within some degree of error.

### Example

An unknown function (sin(x) + cos(2x)) has known INPUT and known TARGET values.
```j
INPUT=: 10 * 3.14159 * 100%~ i. 100
UNKNOWN=: 1&o. + (2&o.@:+:)
TARGET=: UNKNOWN INPUT
```

Create a `SymReg` instance.

```j
NB. population of 60 chromosomes.
NB. each chromosome will contain 10 operators.
NB. only allow 'bt' ops, i.e. basic ops (+-*%) and trig (sin,cos,tan)
sym =: (INPUT;TARGET;60;10;'bt') conew 'SymReg'
solver=: (sym;0.2;10;5;0.001;0;1) conew 'GASolver'
best=: {. 100 fit__solver chromosomes__sym ''
```

After the algorithm is completed, we can extract the 'best fit' function:
```j
]GUESS=: ((>best) {all__sym )`:6
   ] (- ] - 1&o.@:] 1&o.@:] - - - 2&o.@:]) 
```
The best fit function is equivalent to  *sin(sin(x)+x+cos(x))* .

```j
load 'plot'   
plot |: TARGET ,. GUESS INPUT

```

Compare the graphs:

![symreg1](/genetic/symreg1.png)


### Example 2

```j
INPUT=: i: 50
UNKNOWN2 =: 2&o.@:*: - 4&o.
TARGET=: UNKNOWN2 INPUT
sym =: (INPUT;TARGET;60;10;'bthar') conew 'SymReg'
solver=: (sym;0.2;10;5;0.001;0;1) conew 'GASolver'
best=: {. 100 fit__solver chromosomes__sym ''

]GUESS=: ((>best) {all__sym )`:6
   ] (% (] 7&o.@:] % - 5&o.@:] ] ([: %: ]) 7&o.@:] ]))

plot |: TARGET ,. GUESS INPUT
```
![symreg2](/genetic/symreg2.png)



### Example 3
The unknown function is a little more complicated:

`UNKNOWN=: !@:(3&+)@:(2&o.) + ]`

This is equivalent to 

*UNKNOWN = gamma(cos(x)+3)) + x*

```j
INPUT=: i: 50
UNKNOWN2=:!@:(3&+)@:(2&o.) + ]
TARGET=: UNKNOWN2 INPUT
NB. we allow more variety of ops: basic, trig, hyperbolic, inverse
NB. trig and hyperbolic, absolute, root and factorial (gamma) operators.
sym =: (INPUT;TARGET;60;10;'btTHharf') conew 'SymReg'
solver=: (sym;0.2;10;5;0.001;0;1) conew 'GASolver'
NB. 500 interations.
best=: {. 500 fit__solver chromosomes__sym ''
]GUESS=: ((>best) {all__sym )`:6
   ] (+ (] 3&o.@:] 1&o.@:] 6&o.@:] 2&o.@:] + | 3&o.@:] * % %: % %: % 5&o.@:]))
plot |: TARGET ,. GUESS INPUT
```

![symreg3](/genetic/symreg3.png)

The GUESS function is a bit of a monster. We can use *Dissect* to see what is really going on.

```j
load 'debug/dissect'
dissect '( ] (+ (] 3&o.@:] 1&o.@:] 6&o.@:] 2&o.@:] + | 3&o.@:] * % %: % %: % 5&o.@:]))) 1.5'
```
![dissect1](/genetic/dissect1.png)

We can see that some operators are not used. This is not really an issue, other than making the 
solution look scruffy.

After tidying up, the *GUESS* verb is equivalent to: 

*tan(cosh(cos(x)+tan(1/sinh(x))))+x*


### Example 4
We will use Symbolic Regression to approximate a function that will give the ...
To do this we will use the Yacht Hydrodynamics Data Set (http://archive.ics.uci.edu/ml/datasets/yacht+hydrodynamics )

```j
data=: 6 readCSVR_jLearnUtil_ '/path/to/the/yachts.csv'
'X Y Z W'=: splitDataset_jLearnUtil_ data,(0.6;1)
```
*X,Y* are for training, and *Z,W* are for testing.
*X* is the training feature set, and *Y* the target values.

```j
NB. we need to run a lot of iterations
sym =: (X;Y;150;8;'belLtTHhar') conew 'SymReg'
solver=: (sym;0.2;20;10;0.001;0;1) conew 'GASolver'
best=: {. 10000 fit__solver chromosomes__sym ''
]GUESS=: ((>best) {all__sym )`:6
   ] (([: | ]) (3&o.@:] ([: ^. ]) ([: +/ ]) 5&{"1@:] 5&o.@:] 1&o.@:] ^))

```
Even though there is no ordering in the dataset, it is possible to view a line graph
comparison to see how close *GUESS* is at estimating the target values.

```j
plot |: (,Y) ,. GUESS"1 X
```

![symreg41](/genetic/symreg4_1.png)

We can also see the test values comparison.

```j
plot |: (,W) ,. GUESS"1 Z
```

![symreg42](/genetic/symreg4_2.png)

Another interesting point is that *GUESS* only uses the **5th** variable, i.e. 
the *Froude number*.
GUESS is actually equivalent to `|@:^.@:(1&o.)@:^`.

*GUESS=|log(sin(exp(x5)))|*.

It may be surprising how this gives an accurate result
