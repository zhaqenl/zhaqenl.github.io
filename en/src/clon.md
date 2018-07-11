A Clon Guide
============

<img src="/pictures/clon.jpg" class="banner" alt="clon" />
<div style="text-align: right"> 
_Image by Alexis Angelidis via [clon](https://www.lrde.epita.fr/~didier/software/lisp/clon/user.pdf)_ 
</div>

To gain better _context_ (pun retroactively intended) for the incoming discussion, I strongly
suggest you first read the 
[user](https://www.lrde.epita.fr/~didier/software/lisp/clon/user.pdf) and the
[end-user](https://www.lrde.epita.fr/~didier/software/lisp/clon/enduser.pdf) guides, though
Didier Verna suggests you start with the end-user guide.


What is Clon?
-------------

I highly suggest reading the guides linked above first, anyway, and I’ll quote the creator–Clon is a
library for managing command-line options in standalone Common Lisp applications. In comparison to
Python, Common Lisp doesn't have a built-in _intuitive_ library for handling command-line
options. Python has one, and it’s the _getopt_ module (though later in the discussion of Clon, one
might be thinking, as I am now, while writing this–Doesn’t Python have something like this?).


Why use Clon?
-------------

Couldn’t I just go ahead with what Common Lisp provides _in-house_ and get away with additional
_lines_ of code with a bit of compromise in the readability department? You certainly can, but, why
go through all that pain, when a there’s an available tool whose sole purpose is to help you with
that?

What are the main differences? Without Clon, you’d find yourself manually checking for an object’s
membership among the arguments of the command-line, and even with decent code abstraction, code
blocks could significantly be lengthier because of the explicit testings. You also might, as
previously alluded to, sacrifice a bit of code readability just for the sake of 
_having the job done._

With Clon, the user is provided more convenience in creating Common Lisp scripts, that requires the
user to process command-line options, and also equips the user with conveniences, like the trivial
creation of a _help_ page.


Implementation
--------------

The application I’m going to use as the practical example is
[pelo](https://github.com/zhaqenl/pelo), one of my children. As didierverna mentioned, there will be
2 main phases that one needs to traverse in order to use Clon effectively.

So, fire up your browser or your favorite text editor, then open `pelo.lisp` from that repository,
put this window beside the one you just opened, and let’s begin Clon’s whittling.


The initialization phase
------------------------

This first phase is necessary as it will become the hat that the second one will pull its
tricks from. This step requires the creation of two things–the _synopsis_ and the _context._ The
_synopsis_ will become, sort of, like the Common Lisp return value, but sometimes, what we’re after
is not the return value itself, but the side effect (like in a _defun_). For example, inside 
`pelo.lisp`, we accomplished the creation of the _synopsis_ through:

```
(defsynopsis (:postfix "HOST")
  (text :contents "Send ICMP ECHO_REQUEST packets to network hosts. Press C-c, while pelo is
running, to end pelo and show the accumulated stats.
")
  (group (:header "Options:")
         (flag :short-name "h" :long-name "help"
               :description "Print this help.")
         (lispobj :short-name "i" :long-name "interval"
                  :typespec 'fixnum :argument-name "SECONDS"
                  :description "Ping interval.")
         (lispobj :short-name "c" :long-name "count"
                  :typespec 'fixnum :argument-name "NUMBER"
                  :description "Number of packets to send.")
         (flag :short-name "b" :long-name "beep-online"
               :description "Beep if host is up.")
         (flag :short-name "B" :long-name "beep-offline"
               :description "Beep if host is down.")))
```

One of the effects of creating a _synopsis_ is to become the script’s help page. Another one is to
serve as the basis for where the _context_ comes from. Lastly, it implicitly dictates the bounds of
our script, like the options our script supports, or if it supports one at all!

After the creation of the synopsis, we now need to create the _context_, but where do we do that?
Didier Verna mentions that you _cannot_ create a _context_ as a toplevel form, but technically,
Common Lisp would allow you to do that, but the reason you are being discouraged from doing so is
because when created as a toplevel form, the _context_ being created would now be in relation to
when the script is created, not when it will be run, as wanted.

We create a _context_ through the `MAKE-CONTEXT` function, which you’ll notice inside `pelo.lisp`,
is only found in `MAIN`, `HOST-PRESENT`, and `GET-OPT`. What `MAKE-CONTEXT` does, is to _prepare_
for the harvesting of what the command-line contains, which will essentially be the passing of the
baton from the first phase to the second.


The processing phase
--------------------

The question now, is what snowflake of a baton did the first phase just pass to us? There are two
different methods we can use to determine that, and in my case, I didn’t have to choose, because I
used them both!

The first is the _explicit_ method. Here, we _explictly_ check via the `GETOPT` function of Clon,
whether or not a particular option/flag is provided by the end-user, for example:

```
(getopt :short-name "h")
```

In the example above, it checks if the script is given the `-h` flag, which stands for the help
page. In `pelo.lisp`, I also used it to determine whether or not the end-user requested the help
page, either through providing the _short-named_ flag `‑h`, or its _long-named_ equivalent `‑‑help`.

The second method is the _sequential_ one, which is the one that does more work, in my case. Inside,
there are three submethods that it provides us with, as a function and as two macros. The one that
fit my need the best is the `DO-CMDLINE-OPTIONS` macro:

```
(do-cmdline-options (option name value source)
    (cond ((or (string= name "b") (string= name "beep-online")) (setf *beep-online* t))
          ((or (string= name "B") (string= name "beep-offline")) (setf *beep-offline* t))
          ((or (string= name "c") (string= name "count")) (setf *count-p* t)
           (setf *count* value))
          ((or (string= name "i") (string= name "interval")) (setf *interval* value))))
```

`DO-CMDLINE-OPTIONS` is a macro that evaluates its body with `OPTION`, `NAME`, `VALUE`, and
`SOURCE` bound to the return value of the function `GETOPT-CMDLINE`, one of the submethods to
sequentially acquire the next command-line option. So what actually happens is, in a
`DO-CMDLINE-OPTIONS`, `GETOPT-CMDLINE` returns four results which would be bound to the previous
variables, then the body of `DO-CMDLINE-OPTIONS` gets evaluated.

Next, `DO-CMDLINE-OPTIONS` simply loops `GETOPT-CMDLINE` over all the command-line options (while
simultaneously binding them), then evaluates its body. The body of `DO-CMDLINE-OPTIONS` will no
longer be evaluated after the command-line options are exhausted.

Finally, remember that I said previously, that the _synopsis_ implicitly dictates what options our
script can support. The _synopsis_ will also dictate whether our script accepts a non-option
argument. For example, in `pelo`’s case, it accepts a _host_ argument, to be sent a ping request.

For that, Clon offers us the `REMAINDER` function, that gives us the ability to check for
non-option arguments located in the command-line:

```
(defun host-present ()
  "Check if host is provided."
  (remainder :context (make-context)))
```


Miscellaneous
-------------

As the `DO-CMDLINE-OPTIONS` is what I consider to be the cleanest part of the code, I owe it to
where I got the idea from. The idea came from 
[pell](https://github.com/ebzzry/pell/blob/master/pell#L85). 

The previous version of _pelo_ didn’t have that structure at first, which lead me to write a lot of
helper functions to _aid_ (though the code back then was still significantly longer than it is now)
in readability, and for the explicit checks for the options provided to the script.

The worst part is, inside the entry-point function, I had to come up with every single combination
of all the existing options in order to cover all the cases, which works, but is very inefficient
and will give you more unnecessary work, because, if you ever decide to go with that design
philosophy, and you want to add more supported options to your scripts, well, guess what, you’d have
a hard time coming up with all the case combinations.

That’s when I started playing around with the _sequential_ method of acquiring the command-line
options, and doing something with them, which _pell_ helped me with to determine what that
_something_ is.
