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

enum operation {mult, add, double, square};

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
  for item in startItemsStrs[1].split(",") {
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
    if monkeyState[i].op == operation.mult {
      monkeyState[i].op = operation.square;
    } else {
      monkeyState[i].op = operation.double;
    }
  } else {
    monkeyState[i].operand = 
      inputLines[i*linesPer+2][opIdx+2..] : int;
  }

  // Test: divisible by 23
  const testNumIdx = 19;
  monkeyState[i].testNum = 
    inputLines[i*linesPer+3][testNumIdx..] : int;

  // If true: throw to monkey 2
  const trueIdx = 25;
  monkeyState[i].ifTrue = inputLines[i*linesPer+4][trueIdx..] : int;

  // If false: throw to monkey 3
  const falseIdx = 26;
  monkeyState[i].ifFalse = inputLines[i*linesPer+5][falseIdx..] : int;
}

writeln(monkeyState);

proc writeItems() {
  for i in 0..#numMonkeys {
    write("Monkey ", i, ": ");
    for item in monkeyState[i].items {
      write(item, ", ");
    }
    writeln();
  }
}

writeItems();

proc applyOp(op : operation, old : int, operand : int) {
  select op {
    when operation.mult   do return old * operand;
    when operation.add    do return old + operand;
    when operation.double do return old + old;
    when operation.square do return old * old;
    otherwise return -1;
  }
}

// Do rounds and keep track of how many items each
// monkey inspects
var count : [0..#numMonkeys] int;
for round in 1..numRounds {
  for i in 0..#numMonkeys {
    for item in monkeyState[i].items {
      count[i]+=1;
      var opResult = applyOp( monkeyState[i].op, item,
                              monkeyState[i].operand);
      opResult = opResult / 3;
      if opResult % monkeyState[i].testNum == 0 {
        const trueIdx = monkeyState[i].ifTrue;
        monkeyState[trueIdx].items.append(opResult);
      } else {
        const falseIdx = monkeyState[i].ifFalse;
        monkeyState[falseIdx].items.append(opResult);
      }
    }
    monkeyState[i].items.clear();
  }
  writeln();
  writeItems();
}

// compute monkey business
var max1 = max reduce count;
for idx in count.domain {
  if count[idx] == max1 then count[idx]=0;
}
var max2 = max reduce count;
writeln("result = ", max1*max2);

