# matlab

Useful Functions the I've Written for Matlab


# tf_pfe

This function takes an input of a transfer function (1x1 tf) such as

               as + b
Y(s) =   -----------------
           cs^2 + ds + e

which can be defined in matlab as

num = [a b];
den = [c d e];
sys = tf(num,den);

You can use the function as follows

tf_pfe(sys)
