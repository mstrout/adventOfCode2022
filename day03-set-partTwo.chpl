/*
   day03-set-partTwo.chpl

   usage:
    chpl day03-set-partTwo.chpl
    ./day03-set-partTwo < input03b.txt

   Things I needed to look up
   -set intersection is '&'
   -there is no way to easily get a single item out of a set
   -using an array for the first time
 */

use IO, Set;


// Lowercase item types a through z have priorities 1 through 26.
// Uppercase item types A through Z have priorities 27 through 52.
proc calcPriority(item : string) : uint(8) {
  // assuming item is a one character string, FIXME: put in assert
  var unicodeVal = item.byte(0);
  if unicodeVal >= "a".byte(0) {
    return unicodeVal - "a".byte(0) + 1;
  } else {
    return unicodeVal - "A".byte(0) + 26 + 1;
  }
}

// loop through the input
var line : string;
var sharedSet : set(uint(8));
var whichElf = 0;
var rucksack : [0..<3] set(uint(8)); // rucksack for each of the three elves
var total = 0;
for line in stdin.lines() {
  const trimmedLine = line.strip();

  // put the priorities for all of the items in a rucksack into a set
  for item in trimmedLine {
    rucksack[whichElf].add( calcPriority(item) );
  }
  whichElf+=1;
     
  // end of a set of three
  if whichElf==3 {
    const sharedSet = (rucksack[0] & rucksack[1] & rucksack[2]);
    for priority in sharedSet { total += priority; }
    for elf in 0..<3 { rucksack[elf].clear(); }
    whichElf=0; // reset the elf count for next group
  }
}
writeln("total= ", total);

