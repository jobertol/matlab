# matlab

Useful Functions the I've Written for Matlab

  - [Control Systems](#control-systems)
    - [Background](#background-knowledge)
    - [Plot Asymptotes on Bode Plots](#bodeAs)
    - [Partial Fraction Expansion of a Transfer Function](#tf_pfe)
  

## Control Systems


### Background Knowledge

These functions are written for monovariable transfer functions (1x1 tf) such as

This function takes an input of a monovariable transfer function (1x1 tf) such as

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



### bodeAs

Like the Matlab function bode(), this function plots the magnitude and phase portions of a bode plot.
Additionally, it plots the asymptotes and the key frequencies at which asymptotes change.

You can use this function as follows:
`bodeAs(sys);` or `bodeAs(sys,minFreq,maxFreq);`

It is also possible to change the aesthetics of the asymptotes and key frequency markers.
There are five parameters at the beginning of the function:

```
function bodeAs(sys,wLow,wHigh)

    % Parameters for Graph Aesthetics
    lineWidth = 0.5;
    dottedWidth = 1;
    dotColor = 'g';
    asymColor = 'r';
    markSize = 5;
    ...
```

It is fairly intuitive, but for more information read [this](https://www.mathworks.com/help/matlab/ref/linespec.html).

`bodeAs(sys);` will plot
![Image of bodeAs plot](https://github.com/jobertol/matlab/blob/master/Images/bodeAsPlot.jpg)


`bode(sys);` will only plot
![Image of bode plot](https://github.com/jobertol/matlab/blob/master/Images/bodePlot.jpg)

More info on `sys` can be found in the [Background](#background-knowledge) section.



### tf_pfe

You can use this function to display the **Partial Fraction Expansion** of a transfer function:

`
tf_pfe(sys)
`

The output is 

```
           0.0049+0.0239j             0.0049-0.0239j            -0.4996+0.0000j           0.4898+0.0000j   
Y(s) = ----------------------  +  ----------------------  +  ---------------------  +  --------------------
        s-(-9.4253+62.4119j)       s-(-9.4253-62.4119j)       s-(-6.1495+0.0000j)       s-(0.0000+0.0000j) 
```

More info on 'sys' can be found in the [Background](#background-knowledge) section.
