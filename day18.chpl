// day18.chpl

use IO, Map;

var surfArea : map(3*int,int);

// read in each line and grab coordinates
var x,y,z : int;
while readf("%i,%i,%i\n", x, y, z) {

  // check for neighbors, reduce each neighbor count by one
  var numNeigh = 0;
  for diff in ((1,0,0),(0,1,0),(0,0,1),(-1,0,0),(0,-1,0),(0,0,-1)) {
    var neigh = (x,y,z) + diff;
    if surfArea.contains(neigh) {
      numNeigh += 1;
      surfArea[neigh] -= 1;
    }
  }

  // count for this tuple is 6-numNeigh
  surfArea[(x,y,z)] = 6 - numNeigh; 
}

// sum up all the values in the map
writeln("surface area = ", + reduce surfArea.values());
