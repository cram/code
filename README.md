# Data mining, with LISP

<a href="http://doi.org/10.5281/zenodo.1054269"><img src=https://zenodo.org/badge/DOI/10.5281/zenodo.1054269.svg></a>


<img align=right src="http://www.lisperati.com/lisplogo_warning_256.png">



One of my more effective teaching tricks 
(for graduate students) is to:

1. give them a reference system in 
a language they do not know, 
2. Then make them port that code to a language that they do (e.g. Python).

By the time that is done:

- Students have a deep understanding of the core principles invloved;
- Students know many of engineering decisions that might need adjusting when the code is used for
real application;
- Students have the skills required to make, and implement, those decisions.

So here is my reference system for my standard data mining toolkit, written in a language
that it is **very** unlikely that they have ever used before.

Share and enjoy.  This code is currently 0.3. Still an internal hobby. 
But I promise, before version 1.0,  to:

- Port it to asdf/quicklisp before version 1.0.
- Connect this repo to Travis CI.

## Installation

     sudo apt-get install sbcl # linux
     brew installl sbcl        # mac
     git clone http://github.com/cram/code
     
## Example Usage

     cd code/src
     sh lisp fft weather # simple test to see its all working
     
If that all words then you can  use `(load "fft")` to get lots of code
in package `cram:`.

## Geeky stuff

The file `src/Makefile` implements  some (optional) shortcuts that I found 
useful. Fell free to ignore it 

## Todo

### Install into Quicklisp

Of course.

### CI Testing

Hook this into Travis CI using the tricks at
[Prove](https://lispcookbook.github.io/cl-cookbook/testing.html)
[c-travos](https://github.com/luismbo/cl-travis/blob/master/install.sh) or
[ROSWELL](https://github.com/roswell/roswell/wiki/Travis-CI)
or TOML:

- https://github.com/pnathan/pp-toml/blob/master/.travis.yml
- https://travis-ci.org/pnathan/pp-toml/jobs/99057762/config
 
This may   mean replacing my `deftest`s with something from the above.
Such is life.
