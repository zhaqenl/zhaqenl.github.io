Permutations using Backtracking
===============================


Introduction
------------

A permutation is a rearrangement of a given sequence. The difference between a `permutation` and a
`combination` lies in the importance of the ordering of its elements. So, in a combination lock, it
really is not technically correct to be called it that, because, for example, if your lock
combination is `699`, when someone else punches in `969`, it should work too, because in a
combination, the order doesn’t matter, but in a permutation, it does.

So, as an example, in the string sequence `mon`, the possible permutations would, lexicographically,
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

The first block of code is the function that we'll be invoking to do our bidding of `generating` the
permutations.

The value of `raw` will be initialized to the input of the user, and will later be converted to a
list to be initialized to `characters`.

`characters` will serve both as a placeholder to compare the ongoing length of `running`, which will
hold the `still-to-be-ready` next permutation, and as the placeholder to determine what part of
`characters` to append to `running`, next.

Lastly, `bitmask` will serve as the predictor, whether or not the current index of `characters` is
what we’ll need to append to `running`, to get closer to our next permutation.

Inside `permutations()`, the first three `global` statements are to reference the previously
mentioned outside variables, inside the function:

```
global running
global characters
global bitmask
```

Immediately after that, is a condition, which checks if the length of the accumulated value of
`running` is equal to the length of the placeholder `characters`, and if satisfied, means that we
now have a ready permutation to be printed:

```
if len(running) == len(characters):
        print(''.join(running))
```

If the condition is not yet satisfied, it means that we still have more to append to `running`,
before we’re able to output its contents.

For that, we go to the `else` clause of the program:

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

The `for` is to iterate over the indexes of `characters`. Inside, an `if` clause can be found, which
checks whether the current index `i`, is of the `correct` index to be appended to `running`, then
does the `select, explore, then deselect` routine, which is the essence of backtracking, to
accomplish what we need of it, which is to generate the next permutations.

Previously mentioned was the `select, explore, then deselect` routine or the backtracking
routine. The selection part happens literally inside `running.append(characters[i])`, in
`characters[i]` (but the previous `bitmask |= 1 << i` task is also important as I'll discuss later),
the exploration part happens in the recursive call to `permutations()`, and finally, the deselection
part (or undoing) happens in `running.pop()`, wherein, the lastly appended item to `running` is
removed, and in `bitmask ^= 1 << i`, in which the changes to `bitmask` through `bitmask |= 1 << i`
is undone.

Now, what really is the role of `bitmask` in all of this? As you may or may not have already
noticed, this program makes use of bitwise operators to achieve its goals. Firstly, in 
`((bitmask >> i) & 1)`, it checks whether the current index `i` is the appropriate index of 
`characters` to be inserted to `running`. If satisfied, the `bitmask |= 1 << i` task is run, which 
essentially `raises` the threshold of `bitmask` to changes in `i`, so that, when shifted right by 
`i` bits in the next `permutations()` call, `i` will be forced to change its value (in contrast to 
the value of `i` in the outside `for`), so as to force `i` to move to the next index of `characters` 
to possibly insert to `running`.

After the selection and exploration, now comes the deselection part, in which we undo the changes we
made to `bitmask` and `running` to further check if permutations can still be generated. Those are
done through `running.pop()` which removes the last element of `running`, and through `bitmask ^= 1
<< i`.

If after the deselections, the next value of `i` in the `for` loop is still within
`xrange(len(characters))`, the adventure continues through its incrementation and the possible
execution of its body provided that the condition can be satisfied.
