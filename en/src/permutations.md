Permutations using Backtracking
===============================


Introduction
------------

A permutation is a rearrangement of a given sequence. The difference between a _permutation_ and a
_combination_ lies in the importance of the ordering of its elements. So, in a combination lock, it
really is not technically correct to be called it that, because, for example, if your lock
combination is _699_, when someone else punches in _969_, it should work too, because in a
combination, the order doesn’t matter, but in a permutation, it does.

So, as an example, in the string sequence _mon_, the possible permutations would, lexicographically,
be:

```
mon
mno
omn
onm
nmo
nom
```


The Code
--------

The following program accomplishes the task of generating all the possible permutations of a given
string sequence using backtracking:

```
def permutations():
    global running
    global characters
    global bitmask
    if len(running) == len(characters):
        print(''.join(running))
    else:
        for i in xrange(len(characters)):
            if ((bitmask >> i) & 1) == 0:
                bitmask |= 1 << i
                running.append(characters[i])
                permutations()
                bitmask ^= 1 << i
                running.pop()

raw = raw_input()
characters = list(raw)
running = []
bitmask = 0
permutations()
```

The first block of code is the function that we'll be invoking to do our bidding of _generating_ the
permutations.

The value of `RAW` will be initialized to the input of the user, and will later be converted to a
list to be initialized to `CHARACTERS`.

`CHARACTERS` will serve both as a placeholder to compare the ongoing length of `RUNNING`, which will
hold the _still-to-be-ready_ next permutation, and as the placeholder to determine what part of
`CHARACTERS` to append to `RUNNING`, next.

Lastly, `BITMASK` will serve as the predictor, whether or not the current index of `CHARACTERS` is
what we’ll need to append to `RUNNING`, to get closer to our next permutation.

Inside `PERMUTATIONS()`, the first three `GLOBAL` statements are to reference the previously
mentioned outside variables, inside the function:

```
global running
global characters
global bitmask
```

Immediately after that, is a condition, which checks if the length of the accumulated value of
`RUNNING` is equal to the length of the placeholder `CHARACTERS`, and if satisfied, means that we
now have a ready permutation to be printed:

```
if len(running) == len(characters):
        print(''.join(running))
```

If the condition is not yet satisfied, it means that we still have more to append to `RUNNING`,
before we’re able to output its contents.

For that, we go to the `ELSE` clause of the program:

```
else:
        for i in xrange(len(characters)):
            if ((bitmask >> i) & 1) == 0:
                bitmask |= 1 << i
                running.append(characters[i])
                permutations()
                bitmask ^= 1 << i
                running.pop()
```

The `FOR` is to iterate over the indexes of `CHARACTERS`. Inside, an `IF` clause can be found, which
checks whether the current index `I`, is of the _correct_ index to be appended to `RUNNING`, then
does the _select, explore, then deselect_ routine, which is the essence of backtracking, to
accomplish what we need of it, which is to generate the next permutations.

Previously mentioned was the _select, explore, then deselect_ routine or the backtracking
routine. The selection part happens literally inside `RUNNING.APPEND(CHARACTERS[I])`, in
`CHARACTERS[I]` (but the previous `BITMASK |= 1 << I` task is also important as I'll discuss later),
the exploration part happens in the recursive call to `PERMUTATIONS()`, and finally, the deselection
part (or undoing) happens in `RUNNING.POP()`, wherein, the lastly appended item to `RUNNING` is
removed, and in `BITMASK ^= 1 << I`, in which the changes to `BITMASK` through `BITMASK |= 1 << I`
is undone.

Now, what really is the role of `BITMASK` in all of this? As you may or may not have already
noticed, this program makes use of bitwise operators to achieve its goals. Firstly, in 
`((BITMASK >> I) & 1)`, it checks whether the current index `I` is the appropriate index of 
`CHARACTERS` to be inserted to `RUNNING`. If satisfied, the `BITMASK |= 1 << I` task is run, which 
essentially _raises_ the threshold of `BITMASK` to changes in `I`, so that, when shifted right by 
`I` bits in the next `PERMUTATIONS()` call, `I` will be forced to change its value (in contrast to 
the value of `I` in the outside `FOR`), so as to force `I` to move to the next index of `CHARACTERS` 
to possibly insert to `RUNNING`.

After the selection and exploration, now comes the deselection part, in which we undo the changes we
made to `BITMASK` and `RUNNING` to further check if permutations can still be generated. Those are
done through `RUNNING.POP()` which removes the last element of `RUNNING`, and through 
`BITMASK ^= 1 << I`.

If after the deselections, the next value of `I` in the `FOR` loop is still within
`XRANGE(LEN(CHARACTERS))`, the adventure continues through its incrementation and the possible
execution of its body provided that the condition can be satisfied.
