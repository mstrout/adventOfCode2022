// day 13
use IO, Set;


/*
   Plan

   -read in all the pairs into an array of strings
   -convert the strings into a tree or just do a recursive
   algorithm?
   -recursive algorithm
      -if '[' on either then recurse
      -else if both is digit, read an int and compare
        if lhs<rhs then in right order
        else if lhs==rhs then recurse on next char after comma
      -else if lhs=] and rhs is num then right order
      -else if rhs==] and lhs is num then wrong order
*/

var inputLines = readInput();
iter readInput() {
  for line in stdin.lines() do yield line.strip();
}

proc lineIdx(whichPair : int) {
  return (whichPair-1)*3;
}
// assuming a blank line at end of file
const numPairs = inputLines.size/3;
//var rightOrder : [1..numPairs] bool;
var rightOrder : set(int); // hoping I can reduce over set
for whichPair in 1..numPairs {
  var lhs = inputLines[lineIdx(whichPair)];
  var rhs = inputLines[lineIdx(whichPair)+1];
  writeln("lhs = ", lhs);
  writeln("rhs = ", rhs);
  var i = 0;
  if checkRightOrder(lhs, rhs, i, i) then
    rightOrder.add(whichPair);
}
writeln(rightOrder);
writeln(+ reduce rightOrder);

proc findInt(str : string, idx : int, ref numChars, ref val) {
  val = 0;
  var count = 0;
  while (str[idx+count].isDigit()) {
    count += 1;
  }
  numChars = count;
  val = str[idx..#count] : int;
  writeln("numChars = ", numChars);
  writeln("val = ", val);
}

proc checkRightOrder(lhs, rhs : string, 
                     l_idx,r_idx : int) : bool {
  if lhs[l_idx]=='[' && rhs[r_idx]=='[' {
    writeln("lhs[l_idx]=='[' && rhs[r_idx]=='['");
    checkRightOrder(lhs, rhs, l_idx+1, r_idx+1);

  } else if lhs[l_idx]=='[' && rhs[r_idx].isDigit() {
    writeln("lhs[idx]=='[' && rhs[idx].isDigit()");
    checkRightOrder(lhs, rhs, l_idx+1, r_idx);

  } else if rhs[r_idx]=='[' && lhs[l_idx].isDigit() {
    writeln("rhs[idx]=='[' && lhs[idx].isDigit()");
    checkRightOrder(lhs, rhs, l_idx, r_idx+1);

  } else if lhs[l_idx].isDigit() && rhs[r_idx].isDigit() {
    writeln("lhs[idx].isDigit() && rhs[idx].isDigit()"); 
    var l_val, l_numChars, r_val, r_numChars : int;
    findInt(lhs, l_idx, l_numChars, l_val);
    findInt(rhs, r_idx, r_numChars, r_val);
    if l_val < r_val then return true;
    else if l_val > r_val then return false;
    else return checkRightOrder(lhs, rhs, l_idx+l_numChars, r_idx+r_numChars); 

  } else if lhs[l_idx]=="," && rhs[r_idx] == "," {
    writeln("lhs[l_idx]==',' && rhs[r_idx] ==','");
    return checkRightOrder(lhs, rhs, l_idx+1, r_idx+1);

  } else if lhs[l_idx]=="]" && rhs[r_idx] == "]" {
    writeln("lhs[l_idx]==']' && rhs[r_idx] ==']'");
    return checkRightOrder(lhs, rhs, l_idx+1, r_idx+1);

  } else {
    writeln("Not implemented");
  }
  return false;
}

