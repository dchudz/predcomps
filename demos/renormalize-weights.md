## Imagine we have enough exact transitions...

(p. 37 mentions approximating exact transitions)

Suppose:

$v$ consists of only 1 input, which can either be $v=v_1$ or $v=v_2$. For simplicity, assume $u$ only has one possible transition at each $v$. Suppose there's only one possible transition for $u$, $u_a \rightarrow u_b$.

(show example of what this dataset could look like)

Say we have a model $\hat{y} = f(u,v)$. 

Write out what equation (2) says the APC should be. It's something like:

$$.75 \delta_u(u_a \rightarrow u_b, v_1, f) + 0.25 \delta_u(u_a \rightarrow u_b, v_2, f)$$

(todo: write this out more cleanly)

Note that for equation (2) it matters how the $u | v$ is distributed... if for a particular $v$, $u | v$ is almost constant, then that $v$ just gets mostly 0's and doesn't count for anything. Assume here that for each $v$, $u$ is evenly distributed between $u_a$ and $u_b$. (Maybe make these different for $v_1$ and $v_2$ so when we form the pairs it's more clear what's going on)


## Imagine we have to approximate exact transitions

Now $v = v + N(0,epsilon)$

still close to original values...

go to approximation... by forming pairs, compute weights...

* pairs that both come from $v$ near $v_1$ or both near $v_2$ each have high weights, mixed pairs have low weights (good)
* now since there's fewer things for the v's near $v_2$ to pair with, $v_2$ is weighted much less than it should be --- $v_2$ should make up a quarter  


Imagine 2 groups....

75% are one way, 

25% are the other...

make it clear what the 