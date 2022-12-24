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

var visited : set(2*int);
var queue : list((2*int,int)); // coordinate and distance from start

queue.append((startPos,0));

while queue.size > 0 {
  //writeln("queue = ", queue);
  var ((r,c),dist) = queue.pop(0);
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

// FIXME: using a param for these two gave me weird errors
const lowest : int = 0;
const highest  : int = 25;
proc calcHeight(heightStr : string) : int {
  if heightStr=="S" { return 0; }
  else if heightStr=="E" { return 25; }
  else { return (heightStr.byte(0) - "a".byte(0)) : int; }
}

