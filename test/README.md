The tests for this system are spread around the code in `deftest` 
methods.

To run them all:

     cd code/src
     sh lisp fft

To run just one test (say `helloWorld`),  offer it at the command line:

     cd code/src
     sh listp fft helloWorld

If the test funcion has keyword arguments, then these can be altered
on the command line. For example, to print _Hi Tim_ use:

     cd code/src
     sh lisp fft helloWorld :person Tim :salutation Hi

To write new tests:

1. Code it up as a `defun`
2. Work out what values you `want` to see.
3. For each such value add `(test want got)` to the function.
4. Replace `defun` with `deftest`.
5. **IMPORTANT**: Add a documentation string as first line
   of the function (if you do not, that test will 
   always run twice).

