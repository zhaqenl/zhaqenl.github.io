Word Search Python Implementation
=================================

<div class="center">Last updated: September 27, 2018</div>

<img src="/pictures/grid.jpg" class="banner" alt="clon" />

This implementation of word search is, in most part, an experiment. An experiment to see how I
utilize a tool, Python, to try and solve the problem of implementing basic word search solving
algorithm.


Table of Contents
-----------------

- [What is a Word Search puzzle?](#what)
- [How and Where Do We Start?](#how_where)
- [Which tool do we use?](#which)
- [Python Installation](#install)
  + [Windows](#windows)
  + [Linux and Unix](#lunix)
- [Pen and Paper](#pap)
- [Onto the Python code!](#python)
  + [Implementing the Algorithm](#implement)
    * [Functions](#functions)
      * [matrixify](#matrix)
      * [coord_char](#coordChar)
      * [convert_to_word](#toWord)
      * [find_base_match](#base)
      * [matched_neighbors](#neighbors)
      * [complete_line](#completeLine)
      * [complete_match](#completeMatch)
      * [find_matches](#helper)
      * [wordsearch](#main)


<a name="what"></a> What is a Word Search puzzle?
-------------------------------------------------

Word search is a puzzle we usually see in newspapers, and in some magazines, located along the
crossword puzzles. They can be located sometimes in bookstores, around the trivia area, as a
standalone puzzle book, in which the sole content is a grid of characters and a set of words per
page.

How a traditional word search puzzle works is, for a given grid of different characters, you have to
find the hidden words inside the grid. The word could be oriented vertically, horizontally,
diagonally, and also inversely in the previously mentioned directions. After all the words are
found, the remaining letters of the grid expose a secret message.

In some word search puzzles, a limitation exists in the length of the hidden words, in that it
should contain more than 2 characters, and the grid should have a fixed size of 10 x 10, or an
equivalent length and width proportion (which this python implementation doesn’t have).


<a name="how_where"></a> How and Where Do We Start?
---------------------------------------------------

Before going deeper into the computer side of the algorithm, let’s first clarify how we tend to
solve a word search puzzle:

- We look at a hidden word and its first letter then we proceed to look for the first letter
  inside the grid of letters.
- Once we successfully find the first letter of the hidden word inside the grid, we then check the
  neighboring characters of that successful match and check whether the second letter of our word
  matches any of the neighbors of the successful match.
- After confirming a successful match for the second letter of the hidden word through its
  neighbors, we proceed to a much narrower step. After the successful matching of the second letter
  of the word in the successful second match’s neighbors, we then follow-through to a straight line
  from there, hoping to get a third match (and so on) of the hidden word’s letters.


<a name="which"></a> Which tool do we use?
------------------------------------------

To realize this series of steps in solving a word search puzzle, we will utilize a programming
language known for having a syntax similar to pseudo-code—Python.

There are two main versions of Python—versions 2.x and 3.x. For this project, we would be utilizing
version 2.7.


<a name="install"></a> Python Installation
------------------------------------------

For the installation part, we’ll be covering installation instructions for both Windows, Unix, and
Linux.

### <a name="windows"></a> Windows

First, determine whether you’re running a 32-bit or a 64-bit operating system. To do that, click
Start, right-click Computer, then click Properties. You should see whether you’re running on 32-bit
or 64-bit under System type. If you’re running on 32-bit, click on this
[link](https://www.python.org/ftp/python/2.7.15/python-2.7.15.msi) then start the download; if
you’re on 64-bit, click on
[this one](https://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi). Again, take note that
we will be utilizing version 2.7 of Python.

### <a name="lunix"></a> Linux and Unix

Download this [file](https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz) then extract. After
extraction, go inside the extracted directory then run the following:

```
$ ./configure
$ make
$ make install
```

In Linux/Unix, to make sure that we can actually run Python when we enter the `python` command in a
terminal, let’s make sure that the installed Python files can be located by the system.

Type the following, then press Enter on your corresponding shell:

Linux bash shell:
`export PATH="$PATH:/usr/local/bin/python"`

sh or ksh shell:
`PATH="$PATH:/usr/local/bin/python"`

csh shell:
`setenv PATH "$PATH:/usr/local/bin/python"`

For Windows, open your command prompt then type then enter the following command:

`path %path%;C:\Python`


<a name="pap"></a> Pen and Paper
--------------------------------

As problems go in software development or in programming in general, it is better to tackle the
problem with a clear head—going at it with the problem statement and constraints clear in our
minds. What we are going to do first is to outline the initial crucial steps in a word search
puzzle.

First, write the word `dog`, then on the space immediately below it, draw a grid of characters on
the paper, like the following:

```
dog

d o g g
o o g o
g o g d
```

To start the hunt, we look at the first letter of the word `dog`, which is the letter `d`. If,
somehow, the first letter of `dog` doesn’t exist within the grid, it means that we won’t be able to
find the word in it! If we successfully find a character match for the first letter of `dog`, we
then proceed to look at the second letter of `dog`. This time, we are now restricted to look around
among the adjacent letters of the first letter match. If the second letter of `dog` can’t be located
around the adjacent letters of `d` inside the grid, this means that we have to proceed to the next
occurrence of the letter `d` inside the grid.

If we find a successful match around the adjacent letters of the next occurrence of `d` inside the
grid, then the next steps are literally straightforward. For example:

```
      *
      o 
      d
```

In the previous grid, the first letter `d` matched on the corner of the grid, and the word’s second
letter `o` which is adjacent to `d`, also successfully matched. If that’s the case, the next
location in the grid to check for the subsequent matches of the remaining letters of the word `dog`,
will now be in a straight line with the direction drawn from the first letter to the second
letter. In this case, we will check the letter directly above `o` for the third letter of the word
`dog`, which is `g`. If instead of the asterisk, the grid showed:

```
      d
      o 
      d
```

This means that we don’t have a match, and we should be progressing along the grid through going to
the next occurrenct of the first letter. If the asterisk is replaced by the correct missing letter:

```
      g
      o 
      d
```

We have a match! However, for our version of word search, we will not stop there. Instead, we will
count for all the adjacent letters of the letter `d`, then look for the matches of the letter `o`!
For example, if we are presented with the following grid:

```
  g   g
    o o 
      d
```

Then so far, for the word `dog`, we found 2 matches! After all the neighbors of the letter `d` have
been checked for a possible match, we then move to the next occurrence of the letter in the grid.


<a name="python"></a> Onto the Python code!
-------------------------------------------

### <a name="implement"></a> Implementing the Algorithm

With the basic algorithm in mind, we can now start implementing the algorithm from the
[previous](#pap) section.

#### <a name="functions"></a> Functions

##### <a name="matrix"></a> matrixify

```
def matrixify(grid, separator='\n'):
    return grid.split(separator)
```

The purpose of this function is to return a list whose elements are lines of string. This provides
us the ability to index individual elements of the grid through accessing them by their row and
column indices:

```
>>> grid = 'dogg oogo gogd'
>>> matrix = matrixify(grid, ' ')
['dogg', 'oogo', 'gogd']
>>> matrix[1][2]
'g'
```

##### <a name="coordChar"></a> coord_char

```
def coord_char(coord, matrix):
    row_index, column_index = coord
    return matrix[row_index][column_index]
```

Given a coordinate ((row_index, column_index) structure) and the matrix where this coordinate is
supposedly located in, this function returns the element located at that row and column:

```
>>> matrix
['dogg', 'oogo', 'gogd']
>>> coord_char((0, 2), matrix)
'g'
```

##### <a name="toWord"></a> convert_to_word

```
def convert_to_word(coord_matrix, matrix):
    return ''.join([coord_char(coord, matrix) for coord in coord_matrix])
```

This function will run through a list of coordinates through a `for` loop and gets the single length
strings using `coord_char`:

```
>>> [coord_char(coord, matrix) for coord in [(0, 0), (0, 1), (0, 2)]]
['d', 'o', 'g']
```

and then uses the `join()` method of strings to return one single string. The `''` before the
`join()` method is the separator to use in between the strings, but in our case, we want one single
word so we used an empty string separator.

##### <a name="base"></a> find_base_match

```
def find_base_match(char, matrix):
    
    base_matches = [(row_index, column_index) for row_index, row in enumerate(matrix)
                    for column_index, column in enumerate(row)
                    if char == column]

    return base_matches
```

The value of `base_matches` above is computed by a `list comprehension`. A list comprehension is
just another way of constructing a list, albeit a more concise one. The above list comprehension is
roughly equivalent to the following:

```
base_matches = []

for row_index, row in enumerate(matrix):
    for column_index, column in enumerate(row):
        if char == column:
            base_matches.append((row_index, column_index))
```

I used the `enumerate()` function because it appends a counter to an iterable, and that is handy
because the counter’s value could correspond to either the row or column indices of the matrix!

To show that the above code indeed scrolls through the individual characters of `grid`, let’s modify
the body of our `for` loop in order to display the characters and their corresponding coordinates:

```
>>> for row_index, row in enumerate(matrix):
...    for column_index, column in enumerate(row):
...        print column, (row_index, column_index)
...
d (0, 0)
o (0, 1)
g (0, 2)
g (0, 3)
o (1, 0)
o (1, 1)
g (1, 2)
o (1, 3)
g (2, 0)
o (2, 1)
g (2, 2)
d (2, 3)
```

Giving our function `find_base_match` the arguments `d` and `grid`, respectively, we get the
following:

```
>>> find_base_match('d', grid)
[(0, 0), (2, 3)]
```

As you can see from the previous `for` loop output, the coordinates output by our function are
indeed the coordinates where the character `d` matched!

By calling this function, we can determine whether or not to continue with the further steps. If we
deliberately give `find_base_match` a character that is not inside `grid`, like `c`:

```
>>> find_base_match('c', grid)
[]
```

The function returns an empty list! This means, that inside the encompassing function that will call
`find_base_match`, one of the conditions could be:

```
if not find_base_match(char, grid):
    pass
```

##### <a name="neighbors"></a> matched_neighbors

```
def matched_neighbors(coord, second_char, matrix, row_length, column_length):
    row_number, column_number = coord
    neighbors_coordinates = [(row, column) for row in xrange(row_number - 1, row_number + 2)
                             for column in xrange(column_number - 1, column_number + 2)
                             if row_length > row >= 0 and column_length > column >= 0
                             and coord_char((row, column), matrix) == second_char
                             and not (row, column) == coord]

    return neighbors_coordinates
```

This function finds the adjacent coordinates of the given coordinate, wherein the character of that
adjacent coordinate matches the `second_char` argument!

Inside `neighbors_coordinates`, we’re trying to create a list of all the coordinates adjacent the
one we gave, but with some conditions to further filter the resulting coordinate:

```
[(row, column) for row in xrange(row_number - 1, row_number + 2)
for column in xrange(column_number - 1, column_number + 2)
if row_length > row >= 0 and column_length > column >= 0
and coord_char((row, column), matrix) == second_char
and not (row, column) == coord]
```

In the above code snippet, we are creating a list of adjacent coordinates (through `(row, column)`).
Because we want to get the immediate neighbors of a certain coordinate, we deduct 1 from our
starting range then add 2 to our end range, so that, if given a row of 0, we will be iterating
through `xrange(-1, 2)`. Remember that the `range()` and `xrange()` functions is not inclusive of
the end range, which means that it doesn’t include the end range in the iteration (hence, the 2 that
we add at the end range, not only 1):

```
>>> list(xrange(-1, 2))
[-1, 0, 1]
```

We do the same to the column variable, then later, we filter the contents of the final list through
an `if` clause inside the list comprehension. We do that because we don’t want this function to
return coordinates that are out of bounds of the matrix. 

To further hit the nail in the coffin, we also give this function a character as its second
argument. That is because we want to further filter the resulting coordinate. We only want a
coordinate whose string equivalent matches the second character argument that we give the function!

If we want to get the neighbors of the coordinate `(0, 0)`, whose adjacent character in the matrix
should be `c`, call this function with `(0, 0)` as the first argument, the string `c` as the second,
the matrix itself, and the matrix’s row length and column length, respectively:

```
>>> matched_neighbors((0, 0), 'c', matrix, 4, 3)
[]
```

Notice that it returns an empty list, because in the neighbors of the coordinate `(0, 0)`, there is
no coordinate in there that has the string `c` as its string equivalent!

If we replace `c` with `a`:

```
>>> matched_neighbors((0, 0), 'a', matrix, 4, 3)
[(0, 1), (1, 0), (1, 1)]
```

This function returns a list of the adjacent coordinates that match the given character.

##### <a name="completeLine"></a> complete_line

```
def complete_line(base_coord, targ_coord, word_len, row_length, column_length):
    if word_len == 2:
        return base_coord, targ_coord

    line = [base_coord, targ_coord]
    diff_1, diff_2 = targ_coord[0] - base_coord[0], targ_coord[1] - base_coord[1]

    for _ in xrange(word_len - 2):
        line += [(line[-1][0] + diff_1, line[-1][1] + diff_2)]

    if  0 <= line[-1][0] < row_length and 0 <= line[-1][1] < column_length:
        return line

    return []
```

We are now at the stage where functions seem a bit hairier to comprehend! I will attempt to discuss
the thoughts I had before creating this function.

In the [Pen and Paper](#pap) section, after matching the first and second letters of the word inside
the matrix, I mentioned that the next matching steps become narrower. It becomes narrower in the
sense that, after matching the first and second letters of the word, the only thing you need to do
after that is to go straight in the direction that the first and second letters created.

For example:

```
      
      o 
      d
```

In the above grid, once the letters `d` and `o` are found, one only need to go straight in a line
from the first letter `d` to the second letter `o`, then take the direction that `d` took to get to
`o`. In this case, we go upwards of `o` to check for the third letter match:

```
      * <- Check this next.
      o 
      d
```

Another example:

```

  o
d
```

The direction that the above matches create is north-east. This means that we have to check the
place north-east of 'o':

```
    * <- This one.
  o
d
```

With that being said, I wanted a function to give me all the coordinates forming a straight line,
when given two coordinates.

The first problem I had to solve was—Given two coordinates, how do I compute the coordinate of the
third one, which will later form a straight line in the matrix? 

To solve this problem, I tried plotting all the expected goal coordinates, if for example, the first
coordinate match is `(1, 1)` and the second coordinate match is `(0, 0)`:

```
first     (1, 1) (1, 1) (1, 1) (1, 1) (1, 1) (1, 1) (1, 1) (1, 1)
second    (0, 0) (0, 1) (0, 2) (1, 2) (2, 2) (2, 1) (2, 0) (1, 0)
expected (-1,-1)(-1, 1)(-1, 3) (1, 3) (3, 3) (3, 1) (3,-1) (1,-1)
```

While looking at the above plot, an idea came into my mind. What I wanted to get was the amount of
step needed to go from the second coordinate to the third. In hopes of achieving that, I tried
subtracting the row and column values of the first from the second:

```
second    (0, 0) (0, 1) (0, 2) (1, 2) (2, 2) (2, 1) (2, 0) (1, 0)
first     (1, 1) (1, 1) (1, 1) (1, 1) (1, 1) (1, 1) (1, 1) (1, 1)
diff     (-1,-1)(-1, 0)(-1, 1) (0, 1) (1, 1) (1, 0) (1,-1) (0,-1)
```

After that, I tried adding the values of the `diff` row to the values of `second`:

```
second    (0, 0) (0, 1) (0, 2) (1, 2) (2, 2) (2, 1) (2, 0) (1, 0)
diff     (-1,-1)(-1, 0)(-1, 1) (0, 1) (1, 1) (1, 0) (1,-1) (0,-1)
sum      (-1,-1)(-1, 1)(-1, 3) (1, 3) (3, 3) (3, 1) (3,-1) (1,-1)
```

If you look closely, the values of the `sum` row match those of the `expected` row! To summarize, I
get the difference by subracting values of the first coordinate from the values of the second
coordinate, then I add the difference to the second coordinate to arrive at the expected third!

Now, back to the function:

```
def complete_line(base_coord, targ_coord, word_len, row_length, column_length):
    if word_len == 2:
        return base_coord, targ_coord

    line = [base_coord, targ_coord]
    diff_1, diff_2 = targ_coord[0] - base_coord[0], targ_coord[1] - base_coord[1]

    for _ in xrange(word_len - 2):
        line += [(line[-1][0] + diff_1, line[-1][1] + diff_2)]

    if  0 <= line[-1][0] <= row_length and 0 <= line[-1][1] <= column_length:
        return line

    return []
```

For this function, however, I decided pass it the length of the word as an argument for mainly two
reasons—to check for double length words, and for the length of the final list output. We check for
double length words because with words that have lengths of 2, we no longer need to compute for a
third coordinate because the word only needs two coordinates to be complete.

For the second reason, this serves as the quirk of my algorithm. Instead of checking the third
coordinate for a match of the third character (and the subsequent ones), I instead create a list of
coordinates, forming a straight line in the matrix, whose length is equal to the length of the word.

I first create the `line` variable which already contains the coordinates of the first match and the
second match of the word. After that, I get the difference of the second coordinates values and the
first. Finally, I create a `for` loop whose loop count is the length of the word minus 2 (because
`line` already has two values inside). Inside the loop, I append to the `line` list variable a new
coordinate by getting `line`’s last variable values then adding the difference of the second and
first match coordinates.

Finally, to make sure that the created coordinate list can be found inside the matrix, I check the
last coordinate of the `line` variable if it’s within the bounds of the matrix. If it is, I return
the newly created coordinate list, and if not, I simply return an empty list.

Let’s say we want a complete line when given coordinate matches `(0, 0)` and `(1, 1)`, and the
length of our word is 3:

```
>>> core.complete_line((0, 0), (1, 1), 3, 4, 3)
[(0, 0), (1, 1), (2, 2)]
```

If we give the function a word length of 4:

```
>>> core.complete_line((0, 0), (1, 1), 4, 4, 3)
[]
```

it returns an empty list because the last coordinate of the created list went out of bounds.

##### <a name="completeMatch"></a> complete_match

```
def complete_match(word, matrix, base_matches, word_len, row_length, column_length):
    match_candidates = (complete_line(base, neighbor, word_len, row_length, column_length)
                       for base in base_matches
                       for neighbor in matched_neighbors(base, word[1], matrix, row_length,
                                                         column_length))

    return [match for match in match_candidates if convert_to_word(match, matrix) == word]
```

This is the `complete_line` function on steroids. The goal of this function is to apply
`complete_line` to all the neighbors of the first match. After that, it creates a lists of
coordinates whose word equivalent is the same as the word we’re trying to look for inside the
matrix.

For the value of the `match_candidates` variable, I utilize a generator comprehension. These are
like list comprehensions, except, they release their values one by one, only upon request, in
contrast to list comprehensions which return all the contents of the list in one go.

To accomplish the application of `complete_line` to all the neighbors of the first match, I iterate
through all the first matches:

`for base in base_matches`

then inside that `for` loop, I iterate through all the neighbors that `matched_neighbors` gave us:

`for neighbor in matched_neighbors(base, word[1], matrix, row_length, column_length)`

I then put the following statement in the first part of the generator comprehension:

`complete_line(base, neighbor, word_len, row_length, column_length)`

The above generator comprehension is roughly equivalent to:

```
for base in base_matches:
    for neighbor in matched_neighbors(base, word[1], matrix, row_length, column_length):
        yield complete_line(base, neighbor, word_len, row_length, column_length)
```

After the creation of the `match_candidates` variable, we now start going through its values one by
one:

`[match for match in match_candidates if convert_to_word(match, matrix) == word]`

This list comprehension above will filter the `match_candidates` and the resulting list will only
contain coordinates that, when converted to its word counterpart, match the original word we wanted
to find.

Attempting to find the word `dog` inside our matrix returns a list of lists containing matched
coordinates:

```
>>> core.complete_match('dog', matrix, find_base_match('dog'[0], matrix), 3, 3, 4)
[[(0, 0), (0, 1), (0, 2)], [(0, 0), (1, 0), (2, 0)], [(0, 0), (1, 1), (2, 2)], [(2, 3), (1, 3), (0, 3)]]
```

##### <a name="helper"></a> find_matches

```
def find_matches(word, grid, separator='\n'):
    word_len = len(word)
    matrix = matrixify(grid, separator)
    row_length, column_length = len(matrix), len(matrix[0])
    base_matches = find_base_match(word[0], matrix)

    if column_length < word_len > row_length or not base_matches:
        return []
    elif word_len == 1:
        return base_matches

    return complete_match(word, matrix, base_matches, word_len, row_length, column_length)
```

This function will serve as the helper of our main function. Its ultimate goal is to output a list
containing the coordinates of all the possible matches of `word` inside `grid`. For general
purposes, I defined four variables:

- The `word_len` variable whose value is the length of the `word` argument, which will generally be
  useful throughout the script
- The `matrix` variable whose value we get through giving
  `grid` to our `matrixify` function, which will allow us to later be able to index contents of the
  matrix through its row and column indices. 
- The `row_length` and the `column_length` variable of `matrix`
- `base_matches` which contain the coordinates of all the first letter matches of `word`

After the variables, we will do some sanity checks:

```
if column_length < word_len > row_length or not base_matches:
        return []
elif word_len == 1:
        return base_matches
```

The above `if elif` statement will check if the length of `word` is longer than both the
`column_length` and `row_length` and also checks if `base_matches` returns an empty list. If that
condition is not satisfied, it means that `word` can fit inside the matrix, and `base_matches` found
a match! However, if the length of `word` is 1, we simply return `base_matches`.

If the word is longer than 1, we then pass the local variables to `complete_match` for further
processing.

Given `dog`, the string chain `dogg oogo gogd`, and the `' '` separator as arguments:

```
>>> find_matches('dog', 'dogg oogo gogd', ' ')
[[(0, 0), (0, 1), (0, 2)], [(0, 0), (1, 0), (2, 0)], [(0, 0), (1, 1), (2, 2)], [(2, 3), (1, 3),
(0, 3)]]
```

Voila! This is the list, which contain lists of coordinates where the word `dog` matched inside
`dogg oogo gogd`!

##### <a name="main"></a> wordsearch

```
def wordsearch(word, string_grid, separator='\n'):
    return len(find_matches(word, string_grid, separator))
```

This function simply returns the number of matches of running
`find_matches(word, string_grid, separator='\n')`:

```
>>> wordsearch('dog', 'dogg oogo gogd', ' ')
4
```

There are 4 matches of `dog` inside `dogg oogo gogd`!
