// day11

use IO;
use List;

const numRounds = 20;

iter readInput() {
  for line in stdin.lines() {
    yield line.strip();
  }
}

var inputLines = readInput();
//writeln(inputLines);

enum operation {mult, add, double};

record monkey {
  var items : list(int);
  var op : operation;
  // FIXME: when had enum before operation above, syntax error
  var operand : int;
  var testNum : int; // test if divisible by testNum
  var ifFalse : int; // monkey to throw to if test is false
  var ifTrue  : int; // monkey to throw to if test is true
}

// read in instructions per monkey
const linesPer = 7;
const numMonkeys = inputLines.size/linesPer;
writeln("numMonkeys = ", numMonkeys);
writeln("inputLines.size = ", inputLines.size);
var monkeyState : [0..#numMonkeys] monkey;
for i in 0..#numMonkeys {
  // Monkey #, i==# so don't need to parse
  // Starting items: 79, 98
  var startItemsStrs = inputLines[i*linesPer+1].split(":");
  writeln("startItemsStrs[1] = ", startItemsStrs[1]);
  for item in startItemsStrs[1].split(",") {
    writeln("item = ", item);
    monkeyState[i].items.append(item : int); 
  }
  // Operation: new = old * 19
  const opIdx = 21;
  if inputLines[i*linesPer+2][opIdx] == "*" {
    monkeyState[i].op = operation.mult;
  } else {
    monkeyState[i].op = operation.add;
  }
  //writeln("wholeLine=", inputLines[i*linesPer+2], "=");
  var operandStr = inputLines[i*linesPer+2][opIdx+2..];
  if operandStr == "old" {
    monkeyState[i].op = operation.double;
  } else {
    monkeyState[i].operand = 
      inputLines[i*linesPer+2][opIdx+2..] : int;
  }

  // Test: divisible by 23
  const testNumIdx = 19;
  monkeyState[i].testNum = 
    inputLines[i*linesPer+3][testNumIdx..] : int;

  // If true: throw to monkey 2
  const falseIdx = 25;
  monkeyState[i].ifFalse = inputLines[i*linesPer+4][falseIdx..] : int;

  // If false: throw to monkey 3
  const trueIdx = 26;
  monkeyState[i].ifTrue = inputLines[i*linesPer+5][trueIdx..] : int;
}

writeln(monkeyState);


