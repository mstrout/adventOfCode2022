// day24
use IO, List, Set, Map;

var rowSize : int;
var inputGrid = readGrid(rowSize);

var numRows = inputGrid.size/rowSize;
var gridDomain = {1..numRows, 1..rowSize};
var grid = reshape(inputGrid, gridDomain);
//writeln(grid);

// Yields a stripped string for each line in stdin
// and sets the rowSize.
iter readGrid(ref rowSize : int) {
  var line : string;
  while readLine(line) { 
    rowSize = line.strip().size;
    for char in line.strip() { yield char; }
  }
}

// start and target positions
const start = (1,2);
const target = (numRows,rowSize-1);
writeln("target = ", target);

// keep a map of minute -> grid
const stormArea = {2..numRows-1,2..rowSize-1};
var gridMap : map(int,[stormArea] set(2*int));

var firstGrid : [stormArea] set(2*int);
for pos in stormArea {
  const val = grid[pos];
  if val==">" { firstGrid[pos].add((0,1)); }
  if val=="<" { firstGrid[pos].add((0,-1)); }
  if val=="^" { firstGrid[pos].add((-1,0)); }
  if val=="v" { firstGrid[pos].add((1,0)); }
}
//writeln("firstGrid = ", firstGrid);
gridMap[0] = firstGrid;

writeln("first part = ", findShortestPath(start));

// try to modify the BFS from day12 to work in this case
proc findShortestPath(from : 2*int) {
  var visited : set((2*int,int)); // don't want to visit same location in same minute > once
  var queue : list((2*int,int)); // coordinate and minute
  queue.append((start,0));

  var minute : int;
  var currPos : 2*int;
  while queue.size > 0 {
    //writeln("queue = ", queue);
    (currPos, minute) = queue.pop(0);
    writeln("currPos = ", currPos, ", minute = ", minute);

    for diff in ( (0,1), (1,0), (0,0), (-1,0), (0,-1) ) {
      var neigh = currPos + diff;
      //writeln("neigh = ", neigh);
      if neigh==target {
        return minute+1; // since doing BFS, we know this is shortest distance

      } else if (stormArea.contains(neigh) || neigh==start)
                && !visited.contains((neigh,minute+1))
                && clearOfStorms(minute+1, neigh) {
        queue.append((neigh,minute+1));
        visited.add((neigh,minute+1));
      }
    }
  }
  return -1; // shouldn't get here
}

// reads the global gridMap and start
proc clearOfStorms( minute : int, pos : 2*int) : bool {
  if pos==start { return true; }
  if ! gridMap.contains(minute) { moveStorms( minute ); }
  return gridMap[minute][pos].isEmpty();
}

// helper routine that moves all of the storms
// reads the global gridMap
proc moveStorms( minute : int ) {
  var nextGrid : [stormArea] set(2*int);
  for pos in gridMap[minute-1].domain {
    for dir in gridMap[minute-1][pos] {
      var newPos = pos+dir;
      if !stormArea.contains(newPos) { newPos = wrapAround(newPos); }
      nextGrid[newPos].add(dir);
    }
  }
  gridMap[minute] = nextGrid;
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

