/*
   day02-map.chpl

   Given an input file name, reads in the two character strings
   per line.  

   usage:
    chpl day02-map.chpl
    ./day02-map < input02a.txt

   Things I needed to look up
   -had trouble finding a map example
 */

use IO, Map;

/*
   First character represents (A) rock, (B) paper, or
   (C) scissors.  Second character (X) rock, (Y) paper, or
   (Z) scissors.
   Need to determine a scoring.
   0 if second character loses, 3 for draw, and 6 for win.
   Then add in 1 for rock, 2 for paper, and 3 for scissors.
*/
var score : map( (string,string), int);
score[("A","X")] = 4; // 3 + 1
score[("A","Y")] = 8; // 6 + 2
score[("A","Z")] = 3; // 0 + 3
score[("B","X")] = 1; // 0 + 1
score[("B","Y")] = 5; // 3 + 2
score[("B","Z")] = 9; // 6 + 3
score[("C","X")] = 7; // 6 + 1
score[("C","Y")] = 2; // 0 + 2
score[("C","Z")] = 6; // 3 + 3

writeln(score);

var totalScore = 0;

var line : string;

// loop through the input
for line in stdin.lines() {
  const trimmedLine = line.strip();

  totalScore += score[(trimmedLine[0],trimmedLine[2])];
}
writeln("totalScore = ", totalScore);

