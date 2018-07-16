What is Clon and Why You Should Use it
======================================

<div class="center">Last updated: July 16, 2018</div>

<img src="/pictures/clon.jpg" class="banner" alt="clon" />
<div style="text-align: right"> 
_Image by Alexis Angelidis via [clon](https://www.lrde.epita.fr/~didier/software/lisp/clon/user.pdf)_ 
</div>

In my pursuit of creating a Common Lisp successor of [pell](https://github.com/ebzzry/pell), a host
availability monitor, I stumbled upon
[Clon](https://www.lrde.epita.fr/~didier/software/lisp/clon.php). In hopes of taste-testing Clon,
first, I went on to create the mksum subsystem of [scripts](https://github.com/ebzzry/scripts) and
towards the end of this guide, I will talk a bit about the main differences between that experiment
and pell.


Table of Contents
-----------------

- [Preparation](#preparation)
- [What is Clon?](#what)
- [Why use Clon?](#why)
- [Implementation](#implementation)
  + [The initialization step](#initialization)
  + [The processing step](#processing)
    * [Explicit](#explicit)
    * [Sequential](#sequential)
- [The remainder](#remainder)
- [mksum vs. pelo](#vs)
- [Afternotes](#afternotes)


<a name="preparation"></a> Preparation
--------------------------------------

To experiment with what Clon offers itself, start with the installation of some system dependencies,
on Debian and NixOS systems, respectively:

```bash
sudo apt-get install -y sbcl git
```

```bash
nix-env -i sbcl git
```

After fulfilling those, run the following in sbcl:

```
(ql:quickload :clon)
```


<a name="what"></a> What is Clon?
---------------------------------

Clon is an external CL library whose job is to track command-line options and do stuff with them. In
comparison, CL doesn't have a built-in intuitive library for handling command-line options, whereas,
Python has one called the _getopt_ module.

Though, later in the discussion of Clon, one might be thinking, as I am now, while writing
this:“Doesn’t Python have something like this?”


<a name="why"></a> Why use Clon?
--------------------------------

One of the main criteria that should be considered while writing code is readability.

Without Clon, in order to get what you need from the command-line, you’ll often be manually checking
for an object’s membership among the arguments of the command-line, and even with decent code
abstraction, code blocks could significantly be lengthier because of the testings, and the
additional code abstractions. You also might sacrifice a bit of code readability just for the sake
of _having the job done.™_

With Clon, the user is provided more convenience in creating CL scripts that requires the user to
process command-line options. It also equips the user with conveniences, like the trivial creation
of a help page.


<a name="implementation"></a> Implementation
--------------------------------------------

The process of creating a Clon-powered CL script involves two main steps that needs to be done,
sequentially. The first is the initialization step, and the second one is the processing step.

### <a name="initialization"></a> The initialization step

This first step is necessary as it will become the hat that the second step will pull its tricks
from. This step requires the creation of two things–the _synopsis_ and the _context._ The synopsis
will become, sort of, like the CL return value, but sometimes, what we’re after is not the return
value itself, but the side effect (like in a _defun_, the return value is the name of the function
defined).

One of the effects of creating a synopsis is to become the script’s help page. Another one is to
serve as the basis for where the context comes from. Lastly, it implicitly dictates the bounds of
our script, like the options our script supports, or if it supports one, at all!

To walk through those steps in an example, here is a short program that uses Clon:

```
(in-package :cl-user)
(require "asdf")
(asdf:make :net.didierverna.clon)
(use-package :net.didierverna.clon)

(defsynopsis (:postfix "HOST")
    (text :contents "A short program.")
  (group (:header "Options:")
         (flag :short-name "h" :long-name "help"
               :description "Print this help and exit.")))

(defun main ()
  "Entry point"
  (make-context)
  (when (getopt :short-name "h")
    (help)
    (exit)))
```

The first line is for entering the CL-USER package. The second and third lines are for loading Clon,
to be able to use its functions. The `USE-PACKAGE` function will allow us to use the
`(MAKE-CONTEXT)` form instead of the longer `(NET.DIDIERVERNA.CLON:MAKE-CONTEXT)`.

After that, is a `DEFSYNOPSIS` form:

```
(defsynopsis (:postfix "HOST")
    (text :contents "A short program.")
  (group (:header "Options:")
         (flag :short-name "h" :long-name "help"
               :description "Print this help and exit.")))
```

This is one of the conveniences offered by Clon. One of its effect is acting as the program’s
limiter, dictating the possible options that the program is able to support. Another effect is that
it serves as the help page of the created script.

Inside `MAIN`: 

```
(defun main ()
  "Entry point"
  (make-context)
  (when (getopt :short-name "h")
    (help)
    (exit)))
```

the `(MAKE-CONTEXT)` function gets invoked, which works in synergy with the
`DEFSYNOPSIS` form. What `(MAKE-CONTEXT)` does, is to prepare and to set the scope for the
harvesting of what the command-line contains.


### <a name="processing"></a> The processing step

The question now, is what does the first step have in store for us? There are two different methods
we can use to determine that.


#### <a name="explicit"></a> Explicit

The first is the _explicit_ method. Here, we check via the `GETOPT` function of Clon, whether or not
a particular option/flag is provided by the end-user, for example:

```
(defun main ()
  "Entry point"
  (make-context)
  (when (getopt :short-name "h")
    (help)
    (exit)))
```

In the example above, it checks if the script is given the `-h` flag, which stands for the help
page. 


#### <a name="sequential"></a> Sequential

The second method is _sequential_, which is the one that does more work. There are three submethods
that acquires the command-line arguments sequentially, as a function and as two macros, but we’re
only going to tackle the usage of the `do-cmdline-options` macro.

`DO-CMDLINE-OPTIONS` is a macro that evaluates its body with `OPTION`, `NAME`, `VALUE`, and
`SOURCE` bound to the return value of the function `GETOPT-CMDLINE`, one of the submethods to
sequentially acquire the next command-line option. So what actually happens is, in a
`DO-CMDLINE-OPTIONS`, `GETOPT-CMDLINE` returns four results which would be bound to the previous
variables, then the body of `DO-CMDLINE-OPTIONS` gets evaluated.

Next, `DO-CMDLINE-OPTIONS` simply loops `GETOPT-CMDLINE` over all the command-line options (while
simultaneously binding them), then evaluates its body. The body of `DO-CMDLINE-OPTIONS` will no
longer be evaluated after the command-line options are exhausted.

For this method, we’re going to use, as an example, a code snippet from
[pelo](https://github.com/zhaqenl/pelo/blob/master/pelo.lisp#L170), which uses the
`do-cmdline-options` macro:

```
(do-cmdline-options (option name value source)
    (cond ((or (string= name "b") (string= name "beep-online")) (setf *beep-online* t))
          ((or (string= name "B") (string= name "beep-offline")) (setf *beep-offline* t))
          ((or (string= name "c") (string= name "count")) (setf *count-p* t)
           (setf *count* value))
          ((or (string= name "i") (string= name "interval")) (setf *interval* value))))
```

The strategy used above is to scour the context for provided command-line options, then change the
state of the constants, in order to change the behavior of the script.


<a name="remainder"></a> The remainder
--------------------------------------

Finally, remember that I said previously, that the synopsis implicitly dictates what options our
script can support. The synopsis will also dictate whether our script accepts a non-option argument
through the value of its `:POSTFIX` argument, if there is one.

For example, in the synopsis definition of `pelo`, a `(:POSTFIX "HOST")` form can be found, which
means, that aside from supporting options and flags, the script requires one more argument, in our
case, a `HOST`.

For that, Clon offers us the `REMAINDER` function, that gives us the ability to check for mandatory
non-option arguments located in the command-line. In
[pelo](https://github.com/zhaqenl/pelo/blob/master/pelo.lisp#L76):

```
(defun host-present ()
  "Check if host is provided."
  (remainder :context (make-context)))
```

<a name="vs"></a> mksum vs. pelo
--------------------------------

As promised, in this section, we’re going to discuss the only difference between mksum and pelo.  In
`mksum.lisp` of [scripts](https://github.com/zhaqenl/scripts), inside the entry-point function, we
can clearly see the important difference between exclusively utilizing an explicit approach to
getting the command-line arguments, versus utilizing both explicit and sequential approaches:

```
(defun mksum (&rest args)
    "The top-level function"
    (cond ((and (get-opt "s") (get-opt "t") (remainder)) (print-exit (string-with (remainder))))
          ((options-everywhere-p args) (print-exit (weird-with args (first-weird args))))
          ((valued-string-p) (print-preserve #'string-with))
          ((and (get-opt "s") (remainder)) (print-exit (string-without (remainder))))
          ((and (get-opt "t") (remainder)) (print-exit (option-with (remainder))))
          ((remainder) (print-exit (option-without (remainder))))
          ((string-flag-p) (print-preserve #'string-without))
          ((list-flag-p) (print-exit (ironclad:list-all-digests)))
          (t (print-help)))))

```

As I’ve mentioned earlier, even with code abstractions, the block of code still ends up clunky with
all the extra tests, and the _coming-up-with_ of all the possible cases.


<a name="afternotes"></a> Afternotes
------------------------------------

The idea of using the `DO-CMDLINE-OPTIONS` macro came from 
[pell](https://github.com/ebzzry/pell/blob/master/pell#L85). 

The previous version of pelo didn’t have that structure at first, which lead me to write a lot of
helper functions to aid (though, the code back then was still significantly longer than it is now)
in readability, and for the checks for the options provided to the script.

The worst part is, inside the entry-point function, I had to come up with every single combination
of all the existing options in order to cover all the cases (similar to what happened in mksum),
which works, but is very inefficient and will give you more unnecessary work, because if you ever
decide to go with that design philosophy, and you want to add more supported options to your
scripts, you’d have a hard time coming up with all the case combinations.

That’s when I started playing around with the sequential method of acquiring the command-line
options, and doing something with them, which pell helped me with to determine what that something
is.

For a more detailed tutorial of the more advanced features of Clon, I strongly suggest you read the
[user](https://www.lrde.epita.fr/~didier/software/lisp/clon/user.pdf) and the
[end-user](https://www.lrde.epita.fr/~didier/software/lisp/clon/enduser.pdf) guides, though, Didier
Verna suggests you start with the end-user guide.
