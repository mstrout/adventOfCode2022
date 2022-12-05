/*
   day04-solution1.chpl

   usage:
    chpl day04-solution1.chpl
    ./day04-solution1 < input04a.txt

   See associated blog post at 
   https://chapel-lang.org/blog/posts/aoc2022-day04-ranges/.
 */

use IO;

var sumSubset = 0;
var sumOverlap = 0;
var s1, e1, s2, e2: int;

while readf("%i-%i,%i-%i", s1, e1, s2, e2) {
  // Check if the second section assignment a subset
  // of the first or vice versa.
  if (s1<=s2 && e2<=e1) || (s2<=s1 && e1<=e2) {
    sumSubset+= 1;
  }
  // Partial overlap: if both starts are less than
  // the other end, then we have overlap
  if s2<=e1 && s1<=e2 {
    sumOverlap += 1;
  }
}

writeln("sumSubset = ", sumSubset);
writeln("sumOverlap = ", sumOverlap);
