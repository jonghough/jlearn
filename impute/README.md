# Imputation

### Example
Quick example of imputing some data.
The dataset is assumed to be a boxed matrix, and items in need of
imputation are considered to be empty boxes (=a:).

```j
NB. Create a boxed matrix, with some empty boxes.
A=: 6 4 $ (<1.1),(<2),a:,(<4),(<3.44)
┌────┬────┬────┬────┐
│1.1 │2   │    │4   │
├────┼────┼────┼────┤
│3.44│1.1 │2   │    │
├────┼────┼────┼────┤
│4   │3.44│1.1 │2   │
├────┼────┼────┼────┤
│    │4   │3.44│1.1 │
├────┼────┼────┼────┤
│2   │    │4   │3.44│
├────┼────┼────┼────┤
│1.1 │2   │    │4   │
└────┴────┴────┴────┘

NB. impute all empty items using the Mode value for
NB. the relevent column. If multimode then the verb
NB. will select the first item.
imputeWithMode_jLearnImpute_ A
┌────┬────┬────┬────┐
│1.1 │2   │2   │4   │
├────┼────┼────┼────┤
│3.44│1.1 │2   │4   │
├────┼────┼────┼────┤
│4   │3.44│1.1 │2   │
├────┼────┼────┼────┤
│1.1 │4   │3.44│1.1 │
├────┼────┼────┼────┤
│2   │2   │4   │3.44│
├────┼────┼────┼────┤
│1.1 │2   │2   │4   │
└────┴────┴────┴────┘
```
