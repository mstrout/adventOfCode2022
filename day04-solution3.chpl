/*
   day04-solution3.chpl

   usage:
    chpl day04-solution3.chpl
    ./day04-solution3 < input04a.txt

   See associated blog post at 
   https://chapel-lang.org/blog/posts/aoc2022-day04-ranges/.

   This solution was developed by Brad Chamberlain and then slightly edited.
 */

use IO;

// Chapel iterator that reads in all lines of from standard input.
// Assuming that all lines are in the format "%i-%i,%i-%i".
iter readSections() {
  var s1,e1,s2,e2: int;
  while readf("%i-%i,%i-%i", s1, e1, s2, e2) {
    yield (s1..e1, s2..e2);
  }
}

// Creates an array with all elements yielded 
// by the readSections iterator.
var sections = readSections();

// Parall reduction to add up the number of subsets and the number of overlaps.
var sumSubset = 0;
var sumOverlap = 0;
forall (r1,r2) in sections with (+ reduce sumSubset, + reduce sumOverlap) {
  sumSubset += r1.contains(r2) || r2.contains(r1);
  sumOverlap += (r1[r2]).size > 0;
}

writeln("sumSubset= ", sumSubset);
writeln("sumOverlap= ", sumOverlap);
