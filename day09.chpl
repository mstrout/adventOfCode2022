// day09

use IO, Map, List;
var dir : string;
var count : int;

// need to know how big array needs to be.  Iterator
// might be possible but this works as well
var countMap : map( string, int );
var motionList : list( (string,int) );
while readf("%s %i\n", dir, count) {
  writeln("dir = ", dir, ", count = ", count);
  countMap[dir] += count;
  motionList.append( (dir,count) );
}
writeln(countMap);
writeln(motionList);
//writeln(max reduce countMap.values());
//const maxSize = max reduce countMap.values();
const maxL = countMap["L"];
const maxD = countMap["D"];
const maxU = countMap["U"];
const maxR = countMap["R"];
var tailMarks : [-maxD..maxU,-maxL..maxR] bool;

// treating 0,0 like lower left
var tailPos = (0,0);
var headPos = (0,0);
var headDir : map( string, (int, int) );
headDir["U"] = (1,0);
headDir["D"] = (-1,0);
headDir["L"] = (0,-1);
headDir["R"] = (0,1);

for (dir,count) in motionList {
  for i in 0..<count {
    headPos[0] += headDir[dir][0];
    headPos[1] += headDir[dir][1];
    writeln("headPos = ", headPos);
    moveTail(headPos,tailPos);
    writeln("tailPos = ", tailPos);
    tailMarks[tailPos] = true;
  }
}

writeln("answer = ", + reduce tailMarks );

proc moveTail ( headPos : 2*int, ref tailPos : 2*int) {
  var diff = (headPos[0]-tailPos[0], headPos[1]-tailPos[1]);
  //writeln("diff=",diff);
  // checking if far away enough to move
  if abs(diff[0])>=2 || abs(diff[1])>=2 {
    if diff[0] > 0 then tailPos[0] += 1;
    if diff[0] < 0 then tailPos[0] += -1;
    if diff[1] > 0 then tailPos[1] += 1;
    if diff[1] < 0 then tailPos[1] += -1;
  }
  //writeln("tailPos=",tailPos);
}


// Possible input approaches
/* Brad day 08
const Lines = readLines();

iter readLines() {
  use IO;

  var line: string;
  while readLine(line, stripNewline=true) do
    yield line;
}
*/

// day1-readf
/*
var num : int;
while readf("%i", num) {
  writeln("num = ", num);
}
*/

// day1
/*
for line in stdin.lines() {
  const trimmedLine = line.strip();
*/

// day 4
/*
   while readf("%i-%i,%i-%i", s1, e1, s2, e2) {
*/
