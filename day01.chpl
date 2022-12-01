/*
   day01

   Given an input file name, reads in an integer on each line ...

   usage
    chpl day01.chpl
    ./day01 --inputFile="input1a.txt"

   Things I needed to look up
 */

use IO;

config const inputFile = "testin1a.txt";

// open a file and create a reader
var f = open(inputFile, iomode.r);
var reader = f.reader();

/*
// keep track of two depths
var prev, curr : int;
reader.read(prev);  writeln(prev);

// start counting if we have increases
var count = 0;
*/
var curr, currSum, maxSum1, maxSum2, maxSum3 : int;
var line : string;

// loop through the rest
currSum=0;
for line in stdin.lines() {
  const trimmedLine = line.strip();

  //writeln("trimmedLine=",trimmedLine);
  //writeln("empty?",trimmedLine=="");
  if trimmedLine=="" {
    if currSum > maxSum1 {
      maxSum3=maxSum2;
      maxSum2=maxSum1;
      maxSum1 = currSum;
    } else if currSum > maxSum2 {
      maxSum3=maxSum2;
      maxSum2=currSum;
    } else if currSum > maxSum3 {
      maxSum3=currSum;
    }
    writeln("maxSum1=",maxSum1);
    writeln("maxSum2=",maxSum2);
    writeln("maxSum3=",maxSum3);
    currSum = 0;
  } else {
    var x = trimmedLine : int;
    currSum += x;
  }
  //writeln("currSum=", currSum, "maxSum=", maxSum);
}
writeln("maxSum1 = ", maxSum1);
writeln("allThree = ", maxSum1+maxSum2+maxSum3);
/*
while reader.read(curr) {
  writeln("curr=",curr,"end");
}
while reader.readLine(line) {
  writeln(line, ", size=", line.size);
  writeln("line==empty string = ", line=="");
  var x = line : int; // this is getting last digit from prev line when it has the empty line
  writeln("x = ", x);
}
*/

// output the result
//writeln("number of increases = ", count);

