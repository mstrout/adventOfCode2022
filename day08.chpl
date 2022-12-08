/*
   day08.chpl

   questions
   - is it possible to yield elements in a 2D array?
*/
use IO;

var trees = readForest();
writeln(trees);

iter readForest() {
  var line : string;
  var row = 0;
  while readLine(line) {
    var col = 0;
    for treeHeight in line.strip() {
      yield (row, col, treeHeight : int );
      col += 1;
    }
    row +=1;
  }
}

// compute width and height
const lastIndex = trees[trees.size-1][0]; // biggest row
writeln("lastIndex = ", lastIndex);

// create 2D array
var grid : [0..lastIndex][0..lastIndex] int;
var countGrid : [0..lastIndex][0..lastIndex] bool;

for (row,col,treeHeight) in trees {
  grid[row][col] = treeHeight;
}
writeln(grid);

var count = 0;
count += 2*(lastIndex+1);  // top and bottom row
count += 2*(lastIndex-1);  // left and right

const left =  1..<lastIndex;
const right = 1..<lastIndex by -1;
const top =  1..<lastIndex;
const bottom = 1..<lastIndex by -1;
for row in 1..<lastIndex {
  var currMax = grid[row][0];
  for col in left {
    if grid[row][col] > currMax {
      currMax = grid[row][col];
      countGrid[row][col] = true;
    }
  }
  currMax = grid[row][lastIndex];
  for col in right {
    if grid[row][col] > currMax {
      currMax = grid[row][col];
      countGrid[row][col] = true;
    } 
  }
}

for col in 1..<lastIndex {
  var currMax = grid[0][col];
  for row in top {
    if grid[row][col] > currMax {
      currMax = grid[row][col];
      countGrid[row][col] = true;
    }
  }
  currMax = grid[lastIndex][col];
  for row in bottom {
    if grid[row][col] > currMax {
      currMax = grid[row][col];
      countGrid[row][col] = true;
    }
  }
}
writeln("countGrid = ", countGrid);
writeln("+ reduce (+ reduce countGrid) = ", + reduce (+ reduce countGrid));

count += + reduce (+ reduce countGrid);

writeln("count = ", count);

//var scoreGrid : [0..lastIndex][0..lastIndex] int = 1;
// ERROR?: error: cannot iterate over values of type int(64)
var scoreGrid : [0..lastIndex][0..lastIndex] int;
var sum : int;
var maxScore = 0;
for row in 0..lastIndex {
  for col in 0..lastIndex {
    scoreGrid[row][col] = 1; 
    const treeHeight = grid[row][col];

    // go up
    sum = 0;
    for i in 0..row-1 by -1 {
      if grid[i][col] <= treeHeight then sum += 1;
      if grid[i][col] >= treeHeight then break;
    }
    scoreGrid[row][col] *= sum;
    // go down
    sum = 0;
    for i in row+1..lastIndex {
      if grid[i][col] <= treeHeight then sum += 1;
      if grid[i][col] >= treeHeight then break;
    }
    scoreGrid[row][col] *= sum;
    // go right 
    sum = 0;
    for i in col+1..lastIndex {
      if grid[row][i] <= treeHeight then sum += 1;
      if grid[row][i] >= treeHeight then break;
    }
    scoreGrid[row][col] *= sum;
    // go left
    sum = 0;
    for i in 0..col-1 by -1 {
      if grid[row][i] <= treeHeight then sum += 1;
      if grid[row][i] >= treeHeight then break;
    }
    scoreGrid[row][col] *= sum;
    if scoreGrid[row][col] > maxScore then maxScore = scoreGrid[row][col];
  }
}
writeln(scoreGrid);

//writeln("score = ", max reduce (max reduce scoreGrid));
// BUG?: day08.chpl:123: error: 'min(type t)' is not defined for t=[domain(1,int(64),false)] int(64)


// ARGH!! what am I donig wrong?
//for row,col in grid.domain {
//  writeln("row,col = ", (row,col));
//}
