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


