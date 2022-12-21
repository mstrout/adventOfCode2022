// day 21

use IO, Map, List;

enum operation {value, mult, add, divide, subtract};

record monkey {
  var operands : list(string); 
  var op : operation;
  var value : int;
}

var inputLines = readInput();
iter readInput() {
  for line in stdin.lines() do yield line;
}

//writeln(inputLines);
const numMonkeys = inputLines.size;
var monkeyState : map(string,monkey);
for i in 0..#numMonkeys {
  // input format is either
  //    root: pppw + sjmn
  //    dbpl: 5
  var name = inputLines[i][0..3];
  var m : monkey;
  var j = 6;  // index where operand or number will start
  while j<inputLines[i].size && inputLines[i][j].isDigit() { j += 1; }
  if j>6 { m.value = inputLines[i][6..<j] : int; }
  else {
    m.operands.append(inputLines[i][6..#4]);
    m.operands.append(inputLines[i][13..#4]);
    var opstr = inputLines[i][11];
    select opstr {
      when '*' { m.op = operation.mult; }
      when '+' { m.op = operation.add; }
      when '/' { m.op = operation.divide; }
      when '-' { m.op = operation.subtract; }
      otherwise { writeln("unknown op"); }
    }
  }
  monkeyState[name] = m;
}

//writeln(monkeyState);

// uses the global monkeyState dictionary
proc computeValue(m : monkey) : int {
  select m.op {
    when operation.value do return m.value;
    when operation.mult  do return computeValue(monkeyState[m.operands[0]]) * computeValue(monkeyState[m.operands[1]]);
    when operation.add   do return computeValue(monkeyState[m.operands[0]]) + computeValue(monkeyState[m.operands[1]]);
    when operation.divide  do return computeValue(monkeyState[m.operands[0]]) / computeValue(monkeyState[m.operands[1]]);
    when operation.subtract  do return computeValue(monkeyState[m.operands[0]]) - computeValue(monkeyState[m.operands[1]]);
    otherwise return 0;
  }
}

writeln("answer = ", computeValue(monkeyState["root"]));

