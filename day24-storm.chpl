// day24
use IO, List, Set, Map;

var rowSize : int;
var inputGrid = readGrid(rowSize);

var numRows = inputGrid.size/rowSize;
var gridDomain = {1..numRows, 1..rowSize};
var grid = reshape(inputGrid, gridDomain);
writeln(grid);


// Yields a stripped string for each line in stdin
// and sets the rowSize.
iter readGrid(ref rowSize : int) {
  var line : string;
  while readLine(line) { 
    rowSize = line.strip().size;
    for char in line.strip() { yield char; }
  }
}

// storm: ((r,c),dir)
// map: (r,c) -> list(storm)
// keep track of where person is, source, target, and walls
var stormMap : map(2*int,list((2*int,2*int)));
for (pos,val) in zip(gridDomain,grid) {
  if val==">" { stormMap[pos].append((pos,(0,1))); }
  if val=="<" { stormMap[pos].append((pos,(0,-1))); }
  if val=="^" { stormMap[pos].append((pos,(-1,0))); }
  if val=="v" { stormMap[pos].append((pos,(1,0))); }
}
writeln("stormMap = ", stormMap);

const stormArea = {2..rowSize-1,2..numRows-1};
var minute = 0;
var person = (1,2);
var target = (numRows,rowSize-1);
var minTime = gridDomain.size*gridDomain.size; // estimate

writeln("part 1 answer = ", findShortestPath( person, minute, stormMap ) );

// helper routine to find shortest path
proc findShortestPath( curr : 2*int, minute : int, in currMap : map(2*int,list((2*int,2*int))) ) : int {
  if curr==target {
    if minute<minTime { minTime = minute; }
    return minute;
  }
  // move the storms
  var newMap = moveStorms( currMap ); 

  // recurse on all possible places to move the person
  var minList : list(int);
  for dir in ( (0,1), (1,0), (0,0), (-1,0), (0,-1) ) {
    var neigh = curr + dir;
    if !stormArea.contains(neigh) && neigh!=target { continue; }
    if newMap.contains(neigh) { continue; }
    minList.append( findShortestPath(neigh, minute+1, newMap ) );
  }
  writeln("minList = ", minList);
  return min reduce minList;
}


// helper routine that moves all of the storms
proc moveStorms(ref currMap : map(2*int,list((2*int,2*int)))) {
  var newStormMap : map(2*int,list((2*int,2*int)));
  for (r,c) in currMap.keys() {
    for (pos,dir) in currMap[(r,c)] {
      var newPos = pos + dir;
      if !stormArea.contains(newPos) {
        // wrap around
        newPos = wrapAround(newPos);
      }
      newStormMap[newPos].append((newPos,dir));
    }
  }
  return newStormMap;
}

proc wrapAround((r,c) : 2*int) : 2*int {
  if c==1 { // wrap left to right
    return (r,rowSize-1);
  } else if r==1 { // wrap top to bottom
    return (numRows-1,c);
  } else if r==numRows { // wrap bottom to top
    return (2,c);
  } else if c==rowSize { // wrap right to left
    return (r,2);
  }
  return (0,0);
}
/*
// find the start
var startPos : 2*int;
for (pos,str) in zip(gridDomain,grid) {
  if str=="S" {
    startPos = pos;
    break;
  }
}
writeln("startPos = ", startPos);
writeln("part 1: answer = ", findShortestPath(startPos));

var startArray = findStarts();
var pathLength : [0..<startArray.size] int;
for (i,pos) in zip(0..#startArray.size,startArray) {
  pathLength[i] = findShortestPath(pos);
}

writeln("part 2: answer = ", min reduce pathLength);

iter findStarts() {
  for (pos,str) in zip(gridDomain,grid) {
    if str=="S" || str=="a" {
      yield pos;
    }
  }
}

proc findShortestPath(from : 2*int) {
  var visited : set(2*int);
  var queue : list((2*int,int)); // coordinate and distance from start

  queue.append((startPos,0));

  var r, c, dist : int;
  while queue.size > 0 {
    //writeln("queue = ", queue);
    ((r,c),dist) = queue.pop(0);
    //writeln("(r,c) = ", (r,c), ", dist = ", dist);
    if grid[(r,c)] == "E" {
      writeln("Found E");
      writeln("dist = ", dist);
      break;
    }
    var currHeight = calcHeight(grid[(r,c)]);
    for diff in ( (0,1), (1,0), (-1,0), (0,-1) ) {
      var neigh = (r,c) + diff;
      if !gridDomain.contains(neigh) { continue; }
      if calcHeight(grid[neigh]) > currHeight+1 { continue; }
      if visited.contains( neigh ) { continue; }
      queue.append((neigh,dist+1));
      visited.add(neigh);
    }
  }
  return dist;
}

// FIXME: using a param for these two gave me weird errors
const lowest : int = 0;
const highest  : int = 25;
proc calcHeight(heightStr : string) : int {
  if heightStr=="S" { return 0; }
  else if heightStr=="E" { return 25; }
  else { return (heightStr.byte(0) - "a".byte(0)) : int; }
}

*/
