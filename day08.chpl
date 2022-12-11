/*
   day08.chpl

   questions
   - is it possible to yield elements into a 2D array?
   - how do I specify an array formal parameter?
      -don't see it in https://chapel-lang.org/docs/main/primers/arrays.html
      -https://github.com/chapel-lang/chapel/issues/11985, some examples and
       also an example of an issue with generics
      -[][] indicates arrays of arrays, want to just have []

  Solution is quite similar to Daniel's,
  https://cray.slack.com/archives/C04BR9BUN59/p1670480642489869?thread_ts=1670480622.677649&cid=C04BR9BUN59
*/
use IO;

//---- Part 1
var rowSize : int;
var trees = readForest(rowSize);
writeln(trees);

var gridDomain = {1..trees.size/rowSize, 1..rowSize};
var grid = reshape(trees, gridDomain);
writeln(grid);
writeln();

writeln("visible = ", + reduce visible(gridDomain, grid));

//---- Part 2
var gridScore : [gridDomain] int = 1;
forall (r,c) in gridDomain {
  for direction in eachDirection((r,c)) {
    gridScore[(r,c)] *= visibleTrees(grid[r,c], direction);
  }
}

writeln("max score = ", max reduce gridScore);

//---- Helper iterators and procedures

proc visibleTrees(currHeight, (treesInDir, step)) {
  //writeln("currHeight = ", currHeight, ", treesInDir = ", treesInDir);
  var count = 0;
  for i in treesInDir.domain by step {
    count += 1;
    if treesInDir[i] >= currHeight then break;
  }
  return count;
}

// Generates a 1D array of all the tree heights.
iter readForest(ref rowSize : int) {
  var line : string;
  while readLine(line) { 
    rowSize = line.strip().size;
    for treeHeight in line.strip() do
      yield treeHeight : int;
  }
}

iter eachDirection((r,c)) {
  yield (grid[..<r,c], -1);
  yield (grid[r+1..,c], 1);
  yield (grid[r,..<c], -1);
  yield (grid[r,c+1..], 1);
}

// Brad's visible function
proc visible( (r,c), height : int) {
  return && reduce (grid[..<r, c]  < height) ||
         && reduce (grid[r+1.., c] < height) ||
         && reduce (grid[r, ..<c]  < height) ||
         && reduce (grid[r, c+1..] < height);
}

