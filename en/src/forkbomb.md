The Forkbomb
============

In this article, I will clarify how the _Forkbomb_ function works which is written as the following:
`:(){ :|:&};:`


The walkthrough
---------------

- The first `:` is the name of the function and the `()` symbol means, that this indeed is a
  function.
  
- Next, everything inside the `{}` symbols means, that the contents inside those symbols is the
  body of the function (or the activities which the function needs to run).
  
- Inside, we can notice `:|:&`. This means, that this function is a recursive function which
  means, in the body of the function,the function calls itself. In `:|:`, la output of the first `:`
  is redirected to the second `:`.
  
- Next, after `:|:`, we also can see the `&` symbol which means, that the function will run as a
  background process.
  
- Finally, after the `{}` symbols, the `;` symbol means the end of the function. After that, we
  notice another `:`, however, it now means, that we’ll now invoke the function which we just
  defined.
