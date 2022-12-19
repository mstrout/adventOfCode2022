// day17-tetris
use IO;

var input : string;
readLine(input, stripNewline=true);
//writeln(input);

config const width = 7;
config const numRocks = 2022;
const numRockTypes = 5;


var rockPattern : [1..numRockTypes][1..4,1..4] string;
// FIXME: when tried to initialize these to = '.' here got a runtime error
const kindHeight : [1..numRockTypes] int = [1,3,3,4,2];
const kindWidth : [1..numRockTypes] int = [4,3,3,1,2];

// 13 is the number of units with all the rock types stacked on top of each other
const maxHeight = (numRocks/numRockTypes)*13+ (4+ (max reduce kindHeight));
//writeln("maxHeight=", maxHeight);

var simSpace : [1..maxHeight,1..width] string = ".";

// ####
rockPattern[1] = '.';
rockPattern[1][1,1] = "#";
rockPattern[1][1,2] = "#";
rockPattern[1][1,3] = "#";
rockPattern[1][1,4] = "#";

// .#.
// ###
// .#.
rockPattern[2] = '.';
rockPattern[2][2,1] = "#";
rockPattern[2][1,2] = "#";
rockPattern[2][2,2] = "#";
rockPattern[2][2,3] = "#";
rockPattern[2][3,2] = "#";

// ..#
// ..#
// ###
rockPattern[3] = '.';
rockPattern[3][1,1] = "#";
rockPattern[3][1,2] = "#";
rockPattern[3][1,3] = "#";
rockPattern[3][2,3] = "#";
rockPattern[3][3,3] = "#";

// #
// #
// #
// #
rockPattern[4] = '.';
rockPattern[4][1,1] = "#";
rockPattern[4][2,1] = "#";
rockPattern[4][3,1] = "#";
rockPattern[4][4,1] = "#";

// ##
// ##
rockPattern[5] = '.';
rockPattern[5][1,1] = "#";
rockPattern[5][1,2] = "#";
rockPattern[5][2,1] = "#";
rockPattern[5][2,2] = "#";

// do the simulation, x-axis, y-axis
var currHeight = 0;
var lowerLeft = (4,3); // lower left of the first rock
var currInput = 0;
for i in 1..numRocks {
  //writeln("start of for loop, lowerLeft = ", lowerLeft);
  var currKind = (i-1) % numRockTypes + 1;
  //writeln("currKind=", currKind);
  var done = false;
  while !done {
    // move left or right
    //writeln("input[currInput]=", input[currInput]);
    if input[currInput]=='<' && canMoveLeft(currKind, lowerLeft) {
      lowerLeft += (0,-1);
      //writeln("after pushing left, lowerLeft = ", lowerLeft);
    } else if input[currInput]=='>' && canMoveRight(currKind, lowerLeft) {
      lowerLeft += (0,1);
      //writeln("after pushing right, lowerLeft = ", lowerLeft);
    }
    currInput += 1;
    currInput = currInput % input.size;

    // move down if possible or stop
    if canMoveDown(currKind, lowerLeft) {
      lowerLeft = lowerLeft - (1,0);
    } else {
      done = true;
    }
  }

  //writeln("rockPattern[currKind]=", rockPattern[currKind]);
  currHeight = max(currHeight,kindHeight[currKind] + lowerLeft[0]-1);
  //writeln("currHeight = ", currHeight);
  // mark the simulation space
  //writeln("lowerLeft before marking=", lowerLeft);
  for (r,c) in rockPattern[currKind].domain {
    var (simr, simc) = lowerLeft + (r-1,c-1);
    if rockPattern[currKind][r,c]=='#' then
      simSpace[simr,simc] = rockPattern[currKind][r,c];
  }
  lowerLeft = (currHeight+4,3);
  //writeln("lowerLeft=", lowerLeft);
}
//writeln(simSpace);

writeln("currHeight = ", currHeight);

// check if a rock can move down
// rockPattern and simSpace are being accessed
proc canMoveDown(kind : int, lowerLeft : 2*int) : bool {
  if lowerLeft[0] == 1 then return false; // on floor
  for (r,c) in rockPattern[kind].domain {
    var (simr, simc) = lowerLeft + (r-1,c-1);
    if rockPattern[kind][r,c]=='#' 
       && simSpace[simr-1,simc]=='#' then return false;
  }
  return true;
}
// check if a rock can move right
// rockPattern and simSpace are being accessed
proc canMoveRight(kind : int, lowerLeft : 2*int) : bool {
  if (lowerLeft[1]-1+kindWidth[kind]) == width then return false; // on far right boundary
  for (r,c) in rockPattern[kind].domain {
    var (simr, simc) = lowerLeft + (r-1,c-1);
    if rockPattern[kind][r,c]=='#' 
       && simSpace[simr,simc+1]=='#' then return false;
  }
  return true;
}
// check if a rock can move left
// rockPattern and simSpace are being accessed
proc canMoveLeft(kind : int, lowerLeft : 2*int) : bool {
  if lowerLeft[1] == 1 then return false; // on far left boundary
  for (r,c) in rockPattern[kind].domain {
    var (simr, simc) = lowerLeft + (r-1,c-1);
    if rockPattern[kind][r,c]=='#' 
       && simSpace[simr,simc-1]=='#' then return false;
  }
  return true;
}
