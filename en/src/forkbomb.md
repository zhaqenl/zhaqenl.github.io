The Forkbomb
============

<div class="center">Last updated: July 14, 2018</div>

<img src="/pictures/forkbomb.png" class="banner" alt="forkbomb" />
<div style="text-align: right"> _Image by Lapse via [wallhaven](https://whvn.cc/32961)_ </div>

In this article, I will clarify how the harmless-looking _Forkbomb_ function works.


Table of Contents
-----------------

- [The function name](#name)
- [The function body](#body)
- [The recursion](#recursion)
- [The background-ing](#background)
- [The termination then invoking](#invoke)


<a name="name"></a> The function name
-------------------------------------

The first `:` is the name of the function and the `()` symbol means, that this indeed is a function.


<a name="body"></a> The function body
-------------------------------------
  
Next, everything inside the `{}` symbols means, that the contents inside those symbols is the body
of the function (or the activities which the function needs to run).
  

<a name="recursion"></a> The recursion
--------------------------------------

Inside, we can notice `:|:&`. This means, that this function is a recursive function which means, in
the body of the function, the function calls itself. In `:|:`, la output of the first `:` is
redirected to the second `:`.
  

<a name="background"></a> The background-ing
--------------------------------------------

Next, after `:|:`, we also can see the `&` symbol which means, that the function will run as a
background process.
  

<a name="invoke"></a> The termination then invoking
---------------------------------------------------

Finally, after the `{}` symbols, the `;` symbol means the end of the function. After that, we notice
another `:`, however, it now means, that we’ll now invoke the function which we just defined.
