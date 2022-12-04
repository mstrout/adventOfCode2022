/*
   day04.chpl

   usage:
    chpl day04.chpl
    ./day04 < input04a.txt

   Things I needed to look up
    -formatted input, https://chapel-lang.org/docs/main/modules/standard/IO/FormattedIO.html?highlight=readf#FormattedIO.readf
 */

use IO;

var sum = 0;
var totalB = 0;
var s1,e1,s2,e2: int;

while readf("%i-%i,%i-%i", s1, e1, s2, e2) {
  if (s1<=s2 && e2<=e1) || (s2<=s1 && e1<=e2) {
    sum += 1;
  }
  // partial overlap cases
  //  s1 s2 e1 e2
  //  
  //if (s1<=s2 && s2<=e1) || (s2<=s1 && s1<=e2) {
  if s2<=e1 && s1<=e2 {
    totalB += 1;
  }
}

writeln("sum= ", sum);
writeln("totalB= ", totalB);

