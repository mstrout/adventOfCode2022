// day22.chpl
use IO;

// annoying that some lines don't have as many characters as others
// will need to pad with spaces
iter readInput() {
  for line in stdin.lines() {
    yield line;
  }
}

var arrayOfLineStrings = readInput();
writeln(arrayOfLineStrings);

var numRows = arrayOfLineStrings.size-2;
writeln("numRows = ", numRows);

var rowSize : int = max reduce [i in 0..#numRows] arrayOfLineStrings[i].size;
writeln("rowSize = ", rowSize);
rowSize -= 1;  // taking off newline

var dom = {1..numRows,1..rowSize};
var grid : [dom] string;
for (r,c) in dom {
  //writeln("r,c = ", r, ", ", c, ", arrayOfLineStrings[r-1].size = ", arrayOfLineStrings[r-1].size);
  if c-1<arrayOfLineStrings[r-1].size-1 { // last -1 to take off newline
    grid[r,c] = arrayOfLineStrings[r-1][c-1];
  } else {
    grid[r,c] = " ";
  }
}
writeln(grid);

var directions = arrayOfLineStrings[arrayOfLineStrings.size-1];
writeln(directions);

writeln("directions.size = ", directions.size);
var tokens = tokenize(directions);
writeln("tokens = ", tokens);

enum face {right=0, down=1, left=2, up=3};
var facing : face;
var curr : 2*int = findStart();
writeln("curr = ", curr);

// move around grid
for tok in tokens {
  //writeln();
  //writeln("tok = ", tok);
  select tok {
    when "R" { facing = rotateRight( facing ); }
    when "L" { facing = rotateLeft( facing ); }
    otherwise {
      // move forward for given count
      var count = tok : int;
      while count > 0 {
        curr = findNextCoord(curr, facing);
        count -= 1;
        //writeln("curr = ", curr);
      }
    }
  }
  writeln("tok end: facing = ", facing);
  writeln("tok end: curr = ", curr);
}

var (r,c) = curr;
writeln("answer = ", 1000*r + 4*c + facing:int);

proc wrapAroundIfNeeded( curr : 2*int ) : 2*int {
  var (r,c) = curr;
  if r<1 { r=numRows; }
  else if r>numRows { r = 1; }
  else if c<1 { c=rowSize; }
  else if c>rowSize { c = 1; }
  return (r,c);
}

proc findNextCoord(curr : 2*int, facing : face) : 2*int {
  var incr = (0,0);
  select facing {
    when face.right do incr = (0,1);
    when face.down do incr = (1,0);
    when face.left do incr = (0,-1);
    when face.up do incr = (-1,0);
  }

  var next = curr;
  do {
    next = wrapAroundIfNeeded(next + incr);
  } while grid[next]==" ";

  //writeln("next finding first nonblank = ", next);
  if grid[next] == "#" {
    return curr;
  } else {
    return next;
  }
}

proc rotateLeft( curr : face ) : face {
  select curr {
    when face.right do return face.up;
    when face.down do return face.right;
    when face.left do return face.down;
    when face.up do return face.left;
  }
  return face.right; // shouldn't get here
}

proc rotateRight( curr : face ) : face {
  select curr {
    when face.right do return face.down;
    when face.down do return face.left;
    when face.left do return face.up;
    when face.up do return face.right;
  }
  return face.right; // shouldn't get here
}

iter tokenize(directions : string) {
  var i = 0;
  while i<directions.size-1 { // don't want newline
    var tok = "";
    var j=i;
    while directions[j].isDigit() {
      tok += directions[j];
      j += 1;
    }
    if tok.size>0 {
      i=j;
      yield tok;
    } else {
      i += 1;
      yield directions[i-1];
    }
  }
}


// FIXME: trouble specifying formal parameters, reading globals
//proc findStart(grid : [dom] string) : 2*int {
proc findStart() : 2*int {
  for (r,c) in dom {
    if grid[r,c] == "." { return (r,c); }
  }
  return (0,0); // shouldn't get here
}
