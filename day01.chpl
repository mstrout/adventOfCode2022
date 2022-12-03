/*
   day01

   Input is groups of integers with one integer per line and blank lines between
   groups.  Summing up all the integers within each group.
   For part A, need to find the group sum that is the most.
   For part B, need to know the sum of the top three group sums.

   usage
    chpl day01.chpl
    ./day01 < input1a.txt
 */

use IO;

var currSum, maxSum1, maxSum2, maxSum3 : int;
var line : string;

// loop through the rest
currSum=0;
for line in stdin.lines() {
  const trimmedLine = line.strip();

  // after a group of lines, determine if this group's sum is one of the top three
  // this approach does not generalize to more than the top three
  if trimmedLine=="" {
    if currSum > maxSum1 {
      maxSum3=maxSum2; maxSum2=maxSum1; maxSum1 = currSum;
    } else if currSum > maxSum2 {
      maxSum3=maxSum2; maxSum2=currSum;
    } else if currSum > maxSum3 {
      maxSum3=currSum;
    }
    currSum = 0;

  } else {
    // convert the string into an integer and add it to the current sum
    var x = trimmedLine : int;
    currSum += x;
  }
}
// part A answer
writeln("maxSum1 = ", maxSum1);
// part B answer
writeln("allThree = ", maxSum1+maxSum2+maxSum3);

