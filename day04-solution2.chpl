/*
   day04-solution2.chpl

   usage:
    chpl day04-solution2.chpl
    ./day04-solution2 < input04a.txt

   See associated blog post at 
   https://chapel-lang.org/blog/posts/aoc2022-day04-ranges/.
 */

use IO;

var sumSubset = 0;
var sumOverlap = 0;
var s1,e1,s2,e2: int;

while readf("%i-%i,%i-%i", s1, e1, s2, e2) {
  // Initialize a Chapel range for each elf
  var r1 = s1..e1, r2 = s2..e2;

  // Check if the second section assignment a subset 
  // of the first or vice versa.
  if r1.contains(r2) || r2.contains(r1) {
    sumSubset+= 1;
  } 
  // Partial overlap occurs if the intersection of the ranges is non-empty
  const intersection = r1[r2]; // this operator is called slicing? FIXME
  if intersection.size>0 {
    sumOverlap += 1;
  }
}

writeln("sumSubset= ", sumSubset);
writeln("sumOverlap= ", sumOverlap);
