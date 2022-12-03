/*
   day03-set.chpl

   usage:
    chpl day03-set.chpl
    ./day03-set < input03a.txt

   Things I needed to look up
    -string.byte method
    -range (first time?)
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
var total : int;
for line in stdin.lines() {
  var firstHalf : set(uint(8)); // each rucksack gets a new empty set
  const trimmedLine = line.strip();
  const numHalf = line.size/2;
  for i in 0..<numHalf {
    firstHalf.add( calcPriority(line[i]) );
  }
  var sharedItemPriority : uint(8); // FIXME: better error to show this needs a type or initialization
  for i in numHalf..<line.size {
    //writeln("second half, item = ", line[i]);
    const itemPriority = calcPriority(line[i]);
    if firstHalf.contains(itemPriority) {
      sharedItemPriority = itemPriority;
      break;
    }
  }
  total += sharedItemPriority;
}
writeln("total= ", total);
