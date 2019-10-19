# matlab

Useful Functions the I've Written for Matlab


## tf_pfe

This function takes an input of a transfer function (1x1 tf) such as

```
                       12000
Y(s) =   ---------------------------------
         s^4 + 25 s^3 + 4100 s^2 + 24500 s
```

which can be defined in matlab as

```
num = [12000];
den = [1 25 4100 24500 0];
sys = tf(num,den);
```

You can use the function to display the **Partial Fraction Expansion** of the transfer function

`
tf_pfe(sys)
`

The output is 

```
           0.0049+0.0239j             0.0049-0.0239j            -0.4996+0.0000j           0.4898+0.0000j   
Y(s) = ----------------------  +  ----------------------  +  ---------------------  +  --------------------
        s-(-9.4253+62.4119j)       s-(-9.4253-62.4119j)       s-(-6.1495+0.0000j)       s-(0.0000+0.0000j) 
```
