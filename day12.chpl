// day 12
// path finding
// 12/23 4:23- 
// generalizing code to read in a grid of characters
// 5:15, the all possible paths one is not doing so well, need to do breadth first search
use IO, List, Set;

var rowSize : int;
var inputGrid = readGrid(rowSize);
//writeln(inputGrid);

var gridDomain = {1..inputGrid.size/rowSize, 1..rowSize};
var grid = reshape(inputGrid, gridDomain);
//writeln(grid);
writeln("Finished reading grid");


// Yields a stripped string for each line in stdin
// and sets the rowSize.
iter readGrid(ref rowSize : int) {
  var line : string;
  while readLine(line) { 
    rowSize = line.strip().size;
    for char in line.strip() { yield char; }
  }
}


// find the start
var startPos : 2*int;
for (pos,str) in zip(gridDomain,grid) {
  if str=="S" {
    startPos = pos;
    break;
  }
}
writeln("startPos = ", startPos);

// find shortest path to end
var minPath : list(2*int);
var minPathSize = gridDomain.size;
var visited : set(2*int);
findPath( startPos, minPath, visited );
//writeln("minPath = ", minPath);
writeln("minPathSize = ", minPathSize);


// accesses global variables minPath and grid
// NOTE: using "in" intent so can modify local copy of parameters
proc findPath ( currPos : 2*int, in pathSoFar : list(2*int), in alreadyVisited : set(2*int) ) {
  if grid[currPos] == "E" {
    writeln("Found E");
    if pathSoFar.size < minPathSize {
      minPath = pathSoFar;
      minPathSize = minPath.size;
      writeln("minPath = ", minPath);
      writeln("minPathSize = ", minPathSize);
    }
  } else {
    var currHeight = calcHeight(grid[currPos]);
    for diff in ( (0,1), (1,0), (-1,0), (0,-1) ) {
      var neigh = currPos + diff;
      if pathSoFar.size > minPathSize { break; }
      if alreadyVisited.contains( neigh ) { continue; }
      if ! gridDomain.contains( neigh ) { continue; }
      if calcHeight(grid[neigh]) > currHeight+1 { continue; }
      pathSoFar.append(neigh);
      alreadyVisited.add(neigh);
      findPath( neigh, pathSoFar, alreadyVisited );
    }
  }
}


// FIXME: using a param for these two gave me weird errors
const lowest : int = 0;
const highest  : int = 25;
proc calcHeight(heightStr : string) : int {
  if heightStr=="S" { return 0; }
  else if heightStr=="E" { return 25; }
  else { return (heightStr.byte(0) - "a".byte(0)) : int; }
}

