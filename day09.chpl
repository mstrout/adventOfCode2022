// day09

use IO, Map, List;
var dir : string;
var count : int;

// need to know how big array needs to be.  Iterator
// might be possible but this works as well
var countMap : map( string, int );
var motionList : list( (string,int) );
while readf("%s %i\n", dir, count) {
  countMap[dir] += count;
  motionList.append( (dir,count) );
}
writeln(countMap);
writeln(motionList);
const maxL = countMap["L"];
const maxD = countMap["D"];
const maxU = countMap["U"];
const maxR = countMap["R"];
var tailMarks : [-maxD..maxU,-maxL..maxR] bool;

// four possible directions
var headDir : map( string, [0..1] int );
headDir["U"] = [1,0];
headDir["D"] = [-1,0];
headDir["L"] = [0,-1];
headDir["R"] = [0,1];

// an array for all the other knot positions
// treating 0,0 like lower left
config const numKnots = 1;
var knotPos : [0..numKnots][0..1] int;
for i in 0..numKnots do knotPos[i] = [0,0];
writeln(knotPos);

// move the head based on directions and then the rest
for (dir,count) in motionList {
  for i in 0..<count {
    knotPos[0][0] += headDir[dir][0];
    knotPos[0][1] += headDir[dir][1];
    writeln("headPos = ", knotPos[0]);
    for j in 1..numKnots {
      moveTail(knotPos[j-1],knotPos[j]);
      writeln("knotPos[j] = ", knotPos[j]);
    }
    var coord = (knotPos[knotPos.size-1][0],
                 knotPos[knotPos.size-1][1]); // yuck
    tailMarks[coord] = true;
  }
}

writeln("answer = ", + reduce tailMarks );

// TRY out: use an array instead of tuple and try the
// below in the move code
/*
if abs(delta[0])>1 || abs(delta[1])>1 {
    if delta[0]>1 then tail[0] += sgn(delta[0]);
    if delta[1]>1 then tail[1] += sgn(delta[1]);
}

Actually, with promotion, I am wondering if the following would work:
if abs(delta[0])>1 || abs(delta[1])>1 {
    if delta>1 then tail += sgn(delta);
}
*/

proc moveTail ( headPos : [0..1] int, ref tailPos : [0..1] int) {
  //var diff = (headPos[0]-tailPos[0], headPos[1]-tailPos[1]);
  var diff = headPos-tailPos;
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
