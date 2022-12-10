use IO, Map;

var numCycles : map(string,int);
numCycles["addx"] = 2;
numCycles["noop"] = 1;

iter computeAndReadValues(whenToRead : [] int) {
  var line : string;
  var x = 1;            // register we are computing with
  var cycleCount = 1;   // cycles start at 1
  var readCount = 0; // how many values we have read so far
  while readLine(line, stripNewline=true) 
        && readCount<whenToRead.size {
    var lineArray = line.split();
    var cmd = lineArray[0];
    // determine if we should read this cycle
    for 1..#numCycles[cmd] {
      if cycleCount == whenToRead[readCount] {
        readCount += 1;
        yield x;                // reading register value
      }
      cycleCount += 1;
    } // NOTE: when this curly brace was missing got an error
      // at the end of the file, which isn't helpful

    // Do command
    if cmd=="addx" {
      var operand = lineArray[1]; 
      x += operand : int;
    }
  }
}

const whenToRead = [20, 60, 100, 140, 180, 220];

var x = computeAndReadValues(whenToRead);
//writeln("x = ",x);
//writeln("x*whenToRead = ", x*whenToRead);
writeln("answer = ", + reduce (x*whenToRead));
