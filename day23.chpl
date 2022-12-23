// day 23

use IO, Set, List, Map;

//---- Part 1
var rowSize : int;
var trees = readForest(rowSize);
writeln(trees);

var gridDomain = {1..trees.size/rowSize, 1..rowSize};
var grid = reshape(trees, gridDomain);
writeln(grid);
writeln();


iter readForest(ref rowSize : int) {
  var line : string;
  while readLine(line) {
    rowSize = line.strip().size;
    for treeHeight in line.strip() do
      yield treeHeight;
  }
}

// rounds of moving elves
config const numRounds = 10;

var current : set(2*int);
var proposed : set(2*int);

for (r,c) in gridDomain {
  if grid[r,c] == "#" {
    current.add((r,c));
  }
}

writeln(current);

var allDirections : set(2*int);
var northDirections : set(2*int);
var southDirections : set(2*int);
var westDirections : set(2*int);
var eastDirections : set(2*int);

northDirections.add( (-1,-1) ); // NW
northDirections.add( (-1,0) ); //N
northDirections.add( (-1,1) ); // NE

southDirections.add( (1,-1) ); // SW
southDirections.add( (1,0) ); //S
southDirections.add( (1,1) ); // SE

westDirections.add( (-1,-1) ); // NW
westDirections.add( (0,-1) ); //W
westDirections.add( (1,-1) ); // SW

eastDirections.add( (1,1) ); // SE
eastDirections.add( (0,1) ); //E
eastDirections.add( (-1,1) ); // NE

allDirections = northDirections + southDirections + westDirections + eastDirections;

var setList : list(set(2*int));
setList.append(northDirections);
setList.append(southDirections);
setList.append(westDirections);
setList.append(eastDirections);

var dirList : list(2*int); // parallel with set list
dirList.append((-1,0));
dirList.append((1,0));
dirList.append((0,-1));
dirList.append((0,1));

for round in 1..numRounds {
  doRound();
}

// accessing a lot of globals
proc doRound() : bool {
  var nextSet : set(2*int);
  var proposedSet : set(2*int);
  var proposedMap : map(2*int,2*int);
  var dontMove : set(2*int);

  for (r,c) in current {
    //writeln();
    //writeln("r,c = ", (r,c));
    var neighbors : set(2*int);
    for (diffR,diffC) in allDirections do neighbors.add( (diffR,diffC) + (r,c));
    //writeln(neighbors);
    //writeln(neighbors & current);
    // as long as there is at least one elf neighbor
    var neighborElves = neighbors & current;
    if neighborElves.size>0 {
      for (dir,dirSet) in zip(dirList,setList) {
        var dirNeighbors : set(2*int);
        for (diffR,diffC) in dirSet do dirNeighbors.add( (diffR,diffC) + (r,c));
        var dirElves = current & dirNeighbors;
        if dirElves.size==0 {
          var proposed = (r,c) + dir;
          if proposedSet.contains(proposed) {
            proposedSet.remove(proposed);
          } else {
            proposedSet.add( proposed );
            proposedMap[(r,c)] = proposed;
          }
          break;
        }
      } // set over possible directions
    }
  }
  //writeln("proposedSet = ", proposedSet);
  //writeln("proposedMap = ", proposedMap);

  // 2nd part of round, move elf if proposed direction is still in proposedSet
  for (r,c) in current {
    if proposedMap.contains((r,c)) && proposedSet.contains(proposedMap[(r,c)]) {
      nextSet.add( proposedMap[(r,c)] );
    } else {
      nextSet.add( (r,c) );
    }
  }
  if current == nextSet then return true;
  current = nextSet;
  //writeln("current = ", current);

  // shift the directions
  var tempSet = setList.pop(0);
  setList.append(tempSet);
  var tempDir = dirList.pop(0);
  dirList.append(tempDir);
  return false;
}

// compute the bounding box and then subtract the number of elves
var minR, maxR, minC, maxC : int;

var rSet : set(int);
var cSet : set(int);
for (r,c) in current {
  rSet.add(r);
  cSet.add(c);
}

minR = min reduce rSet;
maxR = max reduce rSet;
minC = min reduce cSet;
maxC = max reduce cSet;

writeln("answer = ", (maxR-minR+1)*(maxC-minC+1) - current.size);

// part 2
var count = numRounds;
while ! doRound() do count+= 1;
writeln("part 2 answer = ", count);

