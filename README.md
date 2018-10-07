zhaqenl.github.io
=================

This repository contains the source of [https://zhaqenl.github.io](https://zhaqenl.github.io).


Dependencies
------------

* [JRE](http://java.com/download)
* [emem](https://github.com/ebzzry/emem)


Building
--------

Inside the root directory, run:

    make

If you use Nixpkgs, instead run:

    nix-shell --pure --run make
    
If you want to switch the CSS to day mode, remove the `-k` flag from the `BUILDER` variable inside
`en/Makefile`:

    BUILDER=java -jar ~/bin/emem.jar -k
    

Credits
-------

The template used in the creation of this repository is based on
[skeleton](https://github.com/ebzzry/skeleton).
