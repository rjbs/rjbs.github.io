---
layout: post
title : "solving the 24 game in Forth"
date  : "2016-08-23T14:46:00Z"
tags  : ["forth", "programming"]
---
About a month ago, Mark Jason Dominus posted [a simple but difficult arithmetic
puzzle](http://blog.plover.com/math/17-puzzle.html), in which the solver had to
use the basic four arithmetic operations to get from the numbers (6, 6, 5, 2)
to 17. This reminded me of the [24
Game](https://en.wikipedia.org/wiki/24_Game), which I played when I paid my
infrequent visits to middle school math club.  I knew I could solve this with a
very simple Perl program that would do something like this:

```perl
for my $inputs ( permutations_of( 6, 6, 5, 2 ) ) {
  for my $ops ( pick3s_of( qw( + - / * ) ) ) {
    for my $grouping ( 'linear', 'two-and-two' ) {
      next unless $target == solve($inputs, $ops, $grouping);
      say "solved it: ", explain($inputs, $opts, $grouping);
    }
  }
}
```

All those functions are easy to imagine, especially if we're willing to use
string eval, which I would have been.  I didn't write the program because it
seemed obvious.

On the other hand, I had Forth on my brain at the time, so I decided I'd try to
solve the problem in Forth.  I told Dominus, saying, "As long as it's all
integer division!  Forth '83 doesn't have floats, after all."  First he laughed
at me for using a language with only integer math.  Then he told me I'd need
to deal with fractions.  I thought about how I'd tackle this, but I had a
realization:  I use GNU Forth.  GNU's version of almost everything is weighed
down with oodles of excess features.  Surely there would be floats!

In fact, there are floats in GNU Forth.  They're fun and weird, like most
things in Forth, and they live on their own stack.  If you want to add the
integer 1 to the float 2.5, you don't just cast 1 to int, you move it from the
data stack to the float stack:

```
2.5e0 1. d>f f+
```

This puts 2.5 on the float stack and 1 on the data stack.  The dot in `1.`
doesn't indicate that the number is a float, but that it's a double.  Not a
double-precision float, but a two-cell value.  In the Forth implementation
I'm using, `1` gets you an 8-byte 1 and `1.` gets you a 16-byte 1.  They're
both integer values.   (If you wrote `1.0` instead, as I was often temped to do,
you'd be making a double that stored 10, because the
position of the dot doesn't matter.)  `d>f` takes a double from the top of the
data stack, converts it to a float, and puts it on the top of the float stack.
`f+` pops the top two floats, float-adds them, and pushes the
result back onto the float stack.  Then we could verify that it worked by using
`f.s` to print the entire float stack to the console.

**Important:** You have to keep in mind that there are two stacks, here,
because it's very easy to manipulate the wrong stack and end up with really
bizarre results.  GNU Forth has locally named variables, but I chose to avoid
them to keep the program feeling more like Forth to me.

## initialization

I'm going to run through how my Forth 24 solver works, not in the order its
written, but top-down, from most to least abstract.  The last few lines of the
program, something like `int main` are:

```
17e set-target
6e 6e 5e 2e set-inputs

." Inputs are: " .inputs
." Target is : " target f@ fe. cr
' check-solved each-expression
```

This sets up the target number and the inputs.  Both of these are stored, not
in the stack, but in memory.  It would be possible to keep every piece of the
program's data on the stack, I guess, but it would be a nightmare to manage.
Having words that use more than two or three pieces of data from the stack gets
confusing very quickly.  (In fact, for me, having even one or two pieces can
test my concentration!)

`set-target` and `set-inputs` are words meant to abstract a bit of the
mechanics of initializing these memory locations.  The code to name these
locations, and to work with them, looks like this:

```
create inputs 4 floats allot  \ the starting set of numbers
create target 24 ,            \ the target number

: set-target target f! ;

\ sugar for input number access
: input-addr floats inputs + ;
: input@ input-addr f@ ;
: input! input-addr f! ;
: set-inputs 4 0 do i input-addr f! loop ;
```

`create` names the current memory location.  `allot` moves the next allocation
forward by the size it's given on the stack, so `create inputs 4 floats allot`
names the current allocation space to `inputs` and then saves the next four
floats worth of space for use.  The comma is a word that compiles a value into
the current allocation slot, so `create target 24 ,` allocates one cell of
storage and puts a single-width integer 24 in it.

The words `@` and `!` read from and write to a memory address, respectively.
`set-target` is trivial, just writing the number on the stack to a known memory
location.  Note, though, that it uses `f!`, a variant of `!` that pops the
value to set from the *float* stack.

`set-inputs` is built in terms of `inputs-addr`, which returns the memory
address for given offset from `inputs`.  If you want the final (3rd) input,
it's stored at `inputs` plus the size of three floats.  That's:

```
inputs 3 floats +
```

When we make the three a parameter, we swap the order of the operands to plus so
we can write:

```
floats inputs + ( the definition of input-addr )
```

`set-inputs` loops from zero to three, each time popping a value off of the
float stack and storing it in the next slot in our four-float array at `input`.

## operators

Now we have an array in memory storing our four inputs.  We also want one for
storing our operators.  In fact, we want two: one for the code implements an
operator and one for a name for the operator.  (In fact, we could store only
the name, and then interpret the name to get the code, but I decided I'd rather
have two arrays.)

```
create op-xts ' f+ , ' f- , ' f* , ' f/ ,
create op-chr '+  c, '-  c, '*  c, '/  c,
```

These are pretty similar to the previous declarations: they use `create` to
name a memory address and commas to compile values into those addresses.  (Just
like `f,` compiled a float, `c,` compiles a single char.)  Now, we're also
using ticks.  We're using tick in two ways.  In `' f+`, the tick means "get the
address of the next word and compile that instead of executing the word."
It's a way of saying "give me a function pointer to the next word I name."  In
`'+`, the tick means "give me the ASCII value of the next character in the
input stream."

Now we've got two arrays with parallel indexes, one storing function pointers
(called execution tokens, or *xt*s, in Forth parlance) and one storing single-character names.  We
also want some code to get items out of theses arrays, but there's a twist.
When we iterate through all the possible permutations of the inputs, we can
just shuffle the elements in our array and use it directly.  When we work with
the operators, we need to allow for repeated operators, so we can't just
shuffle the source list.  Instead, we'll make a three-element array to store
the indexes of the operators being considered at any given moment:

```
create curr-ops 0 , 0 , 0 ,
```

We'll make a word `curr-op!`, like ones we've seen before, for setting the op
in position *i*.

```
: curr-op! cells curr-ops + ! ;
```

If we want the 0th current operator to be the 3rd one from the operators array,
we'd write:

```
3 0 curr-op!
```

Then when we want to execute the operator currently assigned to position *i*,
we'd use `op-do`.  To get the name (a single character) of the operator at
position *i*, we'd use `op-c@`:

```
: op-do    cells curr-ops + @ cells op-xts + @ execute ;
: op-c@    cells curr-ops + @ op-chr + c@ ;
```

These first get the value *j* stored in the *i*th position of `curr-ops`, then
get the *j*th value from either `op-xts` or `op-chr`.

## permutations of inputs

To get every permutation of the input array, I implemented [Heap's
algorithm](https://en.wikipedia.org/wiki/Heap%27s_algorithm), which has the
benefit of being not just efficient, but also dead simple to implement.  At
first, I began implementing a recursive form, but ended up writing it
iteratively because I kept hitting difficulties in stack management.  In my
experience, when you manage your own stacks, recursion gets significantly
harder.

```
: each-permutation ( xt -- )
  init-state

  dup execute

  0 >r
  begin
    4 i <= if rdrop drop exit then

    i i hstate@ > if
      i do-ith-swap
      dup execute
      i hstate1+!
      zero-i
    else
      0 hstate i cells + !
      inc-i
    then
  again
  drop
  ;
```

This word is meant to be called with an `xt` on the stack, which is the code
that will be executed with each distinct permutation of the inputs.  That's
what the comment (in parentheses, like this) tells us.  The left side of the
double dash describes the elements consumed from the stack, and the right side
is elements left on this stack.

`init-state` sets the procedure's state to zero.  The state is an array of
counters with as many elements as the array being permuted.  Our implementation
of `each-permutations` isn't generic.  It only works with a four-element array,
because `init-state` works off of `hstate`, a global four element array.  It
would be possible to make the permutor work on different sizes of input, but it
still wouldn't be reentrant, because every call to `each-permutation` shares
a single state array.  You can't just get a new array inside each call, because
there's no heap allocator to keep track of temporary use of memory.

(That last bit is stretching the truth.  GNU Forth does have words for heap
allocation, which just delegate to C's `alloc` and friends.  I think using them
would've been against the spirit of the thing.)

The main body of `each-permutation` is a loop, built using the most generic
form of Forth loop, `begin` and `again`.  `begin` tucks away its position in
the program, and `again` jumps back to it.  This isn't the only kind of loop in
Forth.  For example, `init-state` initializes our four-element state array like
this:

```
: init-state 4 0 do 0 i hstate! loop ;
```

The `do` loop there iterates from 0 to 3.  Inside the loop body (between `do`
and `loop`) the word `i` will put the current iteration value onto the top of
the stack.  It's not a variable, it's a word, and it gets the value by looking
in another stack: the *return* stack.  Forth words are like subroutines.  Every
time you call one, you are planning to return to your call site.  When you
call a word, your program's current execution point (the program counter), plus
one, is pushed onto the return stack.  Later, when your word hits an `exit`, it
pops off that address and jumps to it.

The `;` in a Forth word definition compiles to `exit`, in fact.

You can do really cool things with this.  They're dangerous too, but who wants
to live forever?  For example, you can drop the top item from the return stack
before returning, and do a non-local return to your caller's caller.  Or you
can replace your caller with some other location, and return to that word --
but it will return to your caller's caller when it finishes.  Nice!

Because it's a convenient place to put stuff, Forth ends up using the return
stack to store iteration variables.  They have nothing to do with returning,
but that's okay.  In a tiny language machine like those that Forth targets,
some features have to pull double duty!

`begin` isn't an iterating loop, so there's no special value on top of the
return stack.  That's why I put one there before the loop starts with `0 >r`,
which puts a 0 on the data stack, then pops the top of the data stack to the
top of the return stack.  I'm using this kind of loop because I want to be able
to reset the iterator to zero.  I could have done that with a normal iterating
loop, I guess, but it didn't occur to me at the time, and now that I have
working code, why change it?

Iterator reset works by setting `i` back to 0 with the `zero-i` word.  In a
non-resetting loop iteration, we increment `i` with `inc-i`.  Of course, `i`
isn't a variable, it's a thing on the return stack.  I made these words up, and
they're implemented like this:

```
: zero-i r> rdrop 0 >r >r ;
: inc-i  r> r> 1+ >r >r ;
```

Notice that both of them start with `r>` and end with `>r`.  That's me saving
and restoring the top item of the return stack.  You see, once I call `zero-i`,
the top element of the return stack is *the call site!*  (Well, the call site
plus one.)  I can't just replace it, so I save it to the data stack, mess
around with the second item on the return stack (which is now the top item) and
then restore the actual caller so that when I hit the `exit` generated by the
semicolon, I go back to the right place.  Got it?  Good!

Apart from that stuff, this word is really just the iterative Heap's algorithm
from Wikipedia!

## nested iteration

Now, the program didn't start by using `each-iteration`, but `each-expression`.
Remember?

```
' check-solved each-expression
```

That doesn't just iterate over operand iterations, but also over operations and
groupings.  It looks like this:

```
: each-expression ( xt -- )
  2 0 do
    i 0= linear !
    dup each-opset
    loop drop ;
```

It expects an execution token on the stack, and then calls `each-opset` twice
with that token, setting `linear` to zero for the first call and 1 for the
second.  `linear` controls which grouping we'll use, meaning which of the two
ways we'll evaluate the expression we're building:

```
Linear    : o1 ~ ( o2 ~ ( o3 ~ o4 ) )
Non-linear: (o1 ~ o2) ~ (o3 ~ o4)
```

`each-opset` is another iterator.  It, too, expects an execution token and
repeatedly passes it to something else.  This time, it calls
`each-permutation`, above, once with each possible combination of operator
indexes in `curr-op`.

```
: each-opset ( xt -- )
  4 0 do i 0 curr-op!
    4 0 do i 1 curr-op!
      4 0 do i 2 curr-op!
        dup each-permutation
        loop loop loop drop ;
```

This couldn't be much simpler!  It's exactly like this:

```
for i in (0 .. 3) {
  op[0] = i
  for j in (0 .. 3) {
    op[1] = j
    for k in (0 .. 3) {
      op[3] = k
      each-permutation
    }
  }
}
```

## inspecting state as we run

Now we have the full stack needed to call a given word for every possible
expression.  We have three slots each for one of four operators.  We have four
operands to rearrange.  We have two possible groupings.  We should end up with
`4! x 4³ x 2` expression.  That's 3072.  It should be easy to count them by
passing a counting function to the iteator!

```
create counter 0 ,
: count-iteration
  1 counter +!    \ add one to the counter
  counter @ . cr  \ then print it and a newline
  ;

' count-iteration each-expression
```

When run, we get a nice count up from 1 to 3072.  It works!  Similarly, I
wanted to eyeball whether I got the right equations, so I wrote a number of
different state-printing words, but I'll only show two here.  First was
`.inputs`, which prints the state of the input array.  (It's conventional in
Forth to start a string printing word's name with a dot, and to end a number
printing word's name with a dot.)

```
: .input  input@ fe. ;
: .inputs 4 0 do i .input loop cr ;
```

`.inputs` loops over the indexes to the array and for each one calls `i
.input`, which gets and prints the value.  `fe.` prints a formatted float.
Here's where I hit one of the biggest problems I'd have!  This word prints the
floats in their order in memory, which we might think of as left to right.  If
the array has [8, 6, 2, 1], we print that.

On the other hand, when we actually evaluate the expression, which we'll do a
bit further on, we get the values like this:

```
4 0 do i input@ loop \ get all four inputs onto the float stack
```

Now the stack contains [1, 2, 8, 6].  The order in which we'll evaluate them is
the reverse of the order we had stored them in memory.  This is a big deal!  It
would've been possible to ensure that we operated on them the same way, for
example by iterating from 3 to 0 instead of 0 to 3, but I decided to just leave
it and force myself to think harder.  I'm not sure if this was a good idea or
just self-torture, but it's what I did.

The other printing word I wanted to show is `.equation`, which prints out the
equation currently being considered.

```
: .equation
  linear @
  if
    0 .input 0 .op
    ((
      1 .input 1 .op
      (( 2 .input 2 .op 3 .input ))
    ))
  else
    (( 0 .input 0 .op 1 .input ))
    1 .op
    (( 2 .input 2 .op 3 .input ))
  then
  ." = " target f@ fe. cr ;
```

Here, we pick one of two formatters, based on whether or not we're doing linear
evaluation.  Then we print out the ops and inputs in the right order, adding
parentheses as needed.  We're printing the parens with `((` and `))`, which are
words I wrote.  The alternative would have been to write things like:

```
." ( " 2 .input 2 .op 3 .input ." ) "
```

...or maybe...

```
.oparen 2 .input 2 .op 3 .input
```

My program is tiny, so having very specialized words makes sense.  Forth
programmers talk about how you don't program *in* Forth.  Instead, you program
Forth itself to build the language you want, then do that.  This is my pathetic
dime store version of doing that.  The paren-printing functions look like:

```
: (( ." ( " ;
: )) ." ) " ;
```

## testing the equation

Now all we need to do is write something to actually test whether the equations
hold and tell us when we get a winner.  That looks like this:

```
: check-solved
  this-solution target f@ 0.001e f~rel
  if .equation then ;
```

This is what we passed to `each-expression` at the beginning!  We must be close
to done now...

`this-solution` puts the value of the current expression onto the top of the
(float) stack.  `target f@` gets the target number.  Then we use `f~rel`.
GNU Forth doesn't give you a `f=` operator to test float equality, because
testing float equality without thinking about it is a bad idea, because it's
too easy to lose precision to floating point mechanics.  Instead, there are a
bunch of float comparison operators.  `f~rel` takes three items from the stack
and puts a boolean onto the data stack.  Those items are two values to compare,
and an allowed margin of error.  We're going to call the problem solved if
we're within 0.001 of the target.  If we are, we'll call `equation.` and print
out the solution we found.

The evaluator, `this-solution`, looks like this:

```
: this-solution
  4 0 do i input@ loop

  linear @ if
    2 op-do 1 op-do 0 op-do
  else
    2 op-do
    frot frot
    0 op-do
    fswap
    1 op-do
  then
  ;
```

What could be simpler, right?  We get the inputs out of memory (meaning they're
now in reverse order on the stack) and pick an evaluation strategy based on the
`linear` flag.  If we're evaluating linearly, we execute each operator's
execution token in order.  If we're grouping, it works like this:

```
        ( r1 r2 r3 r4 ) \ first, all four inputs are on the stack
2 op-do ( r1 r2 r5    ) \ we do first op, putting its result on stack
frot    ( r2 r5 r1    ) \ we rotate the third float to the top
frot    ( r5 r2 r1    ) \ we rotate the third float to the top again
                        \ ...so now the "bottom" group of inputs is on top
0 op-do ( r5 r6       ) \ we do the last op, evaluating the bottom group
fswap   ( r6 r5       ) \ we restore the "real" order of the two groups
1 op-do ( r7          ) \ we do the middle op, and have our solution
```

That's it!  That's the whole 24 solver, minus a few tiny bits of trivia.  I've
published [the full source of the
program](https://github.com/rjbs/misc/blob/main/games/solve24.forth) on GitHub.

