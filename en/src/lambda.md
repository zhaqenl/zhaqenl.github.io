The Surface of Lambda Calculus
==============================

<div class="center">Last edited: July 12, 2018</div>

<img src="/pictures/half-lambda.png" class="banner" alt="half-lambda" />
<div style="text-align: right"> _Image by Lapse via [wallhaven](https://whvn.cc/32786)_ </div>

In this short guide, I will discuss how I understood Lambda Calculus through the online journal
entry of _ebzzry_ titled [A Lambda Calculus Primer](https://ebzzry.io/en/lambda-calculus/).


Table of Contents
-----------------

- [What is lambda calculus?](#what)
- [Where do we start?](#where)
- [How to apply lambda calculus functions](#how)
- [Numbers](#numbers)
- [The advanced functions](#advanced)
- [Successor](#successor)
- [Addition](#addition)
- [Multiplication](#multiplication)
- [Boolean functions](#boolean)
- [And or Not?](#aon)
- [Predecessor](#predecessor)


<a name="what"></a> What is lambda calculus?
--------------------------------------------

Lambda Calculus, simply, is a _standard_ method of expressing computations.


<a name="where"></a> Where do we start?
---------------------------------------

Before we proceed to the _meat_ of the topic, we need to define _terms_ that we'll use throughout
this documentation. A _function_ is a piece of code that when executed or _called_, performs a task.
This is what a _basic_ function in lambda calculus looks like:

```
(λa.a)
```

In lambda calculus, this is what they call an _identity function_ and I'll discuss later a bit of
what it does and how it works. Let's dissect a bit what is contained within a lambda calculus
function. The `λ`, which is a greek letter meaning _lambda_, indicates that whatever is after it is
a function. The letter or symbol after the `λ` preceding the `.` is the parameter or the name of the
function, and the succeding letter or symbol after the `.` is the body of the function. Symbols that
reside between the `λ` and `.` are called _bound_ and I'll show you in the next section how these
_bound_ things behave.


<a name="how"></a> How to apply lambda calculus functions
---------------------------------------------------------

We will start with something simple and we'll use the _identity function_ to demonstrate how
function applications work in lambda calculus.

```
(λa.a)b
```

The output of the function application above is `b`. Why, you ask? Let's break it down. The `b` in
the snippet above is what the _identity function_ is applied to. In lambda calculus, what we do is
we substitute the `b` for the first bound variable after the `λ` symbol which is `a`. After the
substitution, which will consume the `a`, we also substitute `b` for every occurrence of the
symbol `a` that appears in the function body which will result in the output `b`. Let's take a
small step forward to attempt to possibly clarify this _application_.

```
(λba.b)r
```

In the snippet above, we will apply the function `(λba.b)` to `r` and I won't tell you the output
yet so let's walk through the process. The symbols before the `.` and after the `λ` are _bound_
but our higher concern is the symbol immediately succeding the `λ` symbol which is `b` because that
is what we will be substituting `r` for. We now substitute `r` for the bound variable `b`, therefore
consuming it, then we also substitute `r` for every occurrence of the bound variable we substituted
inside the function body, which will result to:

```
(λa.r)
```

Last example before we discuss further:

```
(λab.a(b))cd
```

We take `c` then substitute it for the _first_ bound variable `a`:

```
(λb.c(b))d
```

We then take `d` then substitute it for `b` which will result to:

```
cd
```


### <a name="numbers"></a> Numbers

Before we move to the more complicated functions, let's first establish how numbers are expressed as
functions in lambda calculus. As a basis, the number zero is expressed as:

```
(λab.b)
```

To get to 1, we simply append a duplicate of the _first_ bound variable which is `a` immediately
after the `.` which will result to:

```
(λab.ab)
```


<a name="advanced"></a> The advanced functions
----------------------------------------------


### <a name="successor"></a> Successor

We'll start first with the Successor function which is defined as:

```
(λabc.b(abc))
```

What this function does is it finds the result after adding one to a whole number. Let's try it with
the number two:

```
(λabc.b(abc))2
(λabc.b(abc))(λde.d(d(e)))
```

Substitute the first bound variable `a` with the function for number two:

```
(λbc.b((λde.d(d(e)))bc))
```

We now apply the number two function to the `bc` in the function body:

```
(λbc.b((λe.b(b(e)))c))
(λbc.b(b(b(c))))
```

The result is now the function for number three.


### <a name="addition"></a> Addition

To _add_ in lambda calculus, you just need to modify a little your usage of the _successor_
function. With addition, you position the successor function in between the whole numbers you're
trying to add or simply called as an _infix_, like this:

```
1S2
```

You can further _reduce_ it in a way through spelling out the equivalent functional notation which
is equivalent to _one S (single S)_ and a 2.

```
S2
```

We now do the _magic_ of expansion then reduction:

```
S2
(λabc.b(abc))2
(λbc.b(2bc))
(λbc.b((λde.d(d(e)))bc))
(λbc.b((λe.b(b(e)))c))
(λbc.b(b(b(c))))
= 3
```


### <a name="multiplication"></a> Multiplication

To _multiply_, instead of putting the function in between the numbers or as an infix, we'll use a
prefix syntax. The multiplication function is defined as:

```
(λabc.a(bc))
```

To multiply two and two, we proceed like this:

```
(λabc.a(bc))22
(λbc.2(bc))2
(λc.2(2c))
(λc.(λde.d(d(e)))(2c))
(λc.(λde.d(d(e)))((λfg.f(f(g)))c))
(λc.(λde.d(d(e)))(λg.c(c(g))))
(λc.(λe.(λg.c(c(g)))((λg.c(c(g)))e)))
(λc.(λe.(λg.c(c(g)))(c(c(e)))))
(λc.(λe.(c(c(c(c(e)))))))
= (λce.c(c(c(c(e)))))
= 4
```


### <a name="boolean"></a> Boolean functions

The true and false functions in lambda calculus are pretty simple:

```
True(T) = (λab.a)
False(F) = (λab.b)
```

What the functions above do is when given a pair to be applied to like `ab` or `cd`, the `true`
function will result in the first of the pair hence `a` while the `false` function will give the
second, `b`. Let's experiment:

```
Tsz = (λab.a)sz
(λb.s)z
= s

Fsz = (λab.b)sz
(λb.b)z
= z
```


### <a name="aon"></a> And or Not?

For these three logical operators, we'll import from the boolean functions:

```
And(∧) = λab.ab(λcd.d) = λab.ab(F)
Or(∨) = λab.a(λcd.c)b = λab.a(T)b
Not(¬) = λa.a(λbc.c)(λde.d) = λa.a(F)(T)
```

Let's try the Not function on `F`

```
¬F
λa.a(λbc.c)(λde.d)F
λa.a(λbc.c)(λde.d)(λfg.g)
= (λbc.c)(λde.d)(λfg.g)
= FFT
(λbc.c)(λfg.g)(λde.d)
(λc.c)(λde.d)
(λde.d)
= T
```


### <a name="predecessor"></a> Predecessor

The predecessor function is the function _reverse_ of the successor function because instead of
adding 1, you deduct 1 from the whole number you are applying it to.

Before we proceed to defining the actual predecessor function, we have to _define_ first, in a way,
the prerequisite information needed to have a better understanding of how the predecessor function
was formed.

First, you'll be needing a _pair_ which looks like (b, a), but in this pair, the first element is
one notch higher than the second element, meaning, the first element `b` is the successor of the
second element `a` which also means that `a` is the predecessor of `b`. With that being said, to
determine the predecessor of `a`, you create a pair like the one previously mentioned, select the
second element (which is done by the false boolean function), then it will look like (a, ?).

A pair in lambda calculus function form looks like:

```
(λa.a(bc))
```

To serve as the base for the final form of the predecessor function, we'll use the zeroth pair:

```
(λc.c(00))
```

One last thing before we proceed to the final form of the predecessor function, we'll define a
separate function whose task is to take a pair, then output a new pair, wherein in this new pair,
the first element is the successor of the second element:

```
Z
(λab.b(S(aT))(aT))
```

Let's apply it to our zeroth pair:

```
Z(λc.c(00))
(λab.b(S(aT))(aT))(λc.c(00))
(λab.b(S(aT))(aT))(λc.c((λhi.i)(λhi.i)))
(λb.b(S((λc.c((λhi.i)(λhi.i)))T))((λc.c((λhi.i)(λhi.i)))T))
(λb.b(S(λhi.i))(λhi.i))
(λb.b(λhi.h(i)(λhi.i)))
(λb.b10)
```

We can now build the main predecessor function:

```
P
(λa.aZ(λc.c(00)))F
```

You'll notice that the main difference is that there's a `false` boolean function appended at the
end and that will _select_ the second element from the resulting _pair_ which will be the
_predecessor_ element we're looking for. Let's test it on the number one:

```
P1
((λa.aZ(λc.c(00)))F)1
(1Z(λc.c(00)))F
(λab.abZ(λc.c(00)))F
(λab.ab(λab.b((S(aT))(aT)))(λc.c(λrm.m)(λrm.m)))(λfg.g)
(λb.(λab.b((S(aT))(aT)))(λc.c(λrm.m)(λrm.m))b)(λfg.g)
((λab.b((S(aT))(aT)))(λc.c(λrm.m)(λrm.m)))(λfg.g)
(λb.b((S((λc.c(λrm.m)(λrm.m))T))((λc.c(λrm.m)(λrm.m))T)))(λfg.g)
(λb.b((S(λrm.m))(λrm.m)))(λfg.g)
(λb.b((λrm.r(m))(λrm.m)))(λfg.g)
(λfg.g) ((λrm.r(m))(λrm.m))
(λg.g)(λrm.m)
(λrm.m)
= 0
```

With the predecessor function being built, the subtraction function can now be formulated:

```
R
(λab.bPa)
```

The function above means that the _larger_ element `b` comes before the _smaller_ element `a` and in
between them is the predecessor function. Let's try it with two and one:

```
R21
(λab.bPa)(λcd.c(c(d)))(λcd.c(d))
(λb.bP(λcd.c(c(d))))(λcd.c(d))
(λcd.c(d))(P(λcd.c(c(d))))
(λcd.c(d))(λcd.c(d))
(λd.(λcd.c(d))d)
(λcd.c(d))
= 1
```
