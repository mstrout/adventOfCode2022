// day 21

use IO, Map, List;

enum operation {value, mult, add, divide, subtract};

record monkey {
  var name : string;
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
  var m : monkey;
  m.name = inputLines[i][0..3];
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
  monkeyState[m.name] = m;
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

writeln("part one answer = ", computeValue(monkeyState["root"]));

// part two
writeln("part two answer = ", computeHumanValue(monkeyState["root"],0));

proc dependsOnHuman(m : monkey) : bool {
  if m.op == operation.value && m.name=="humn" {
    return true;
  } else if m.op == operation.value {
    return false;
  } else {
    var op0 = m.operands[0];
    var op1 = m.operands[1];
    return dependsOnHuman(monkeyState[m.operands[0]]) || dependsOnHuman(monkeyState[m.operands[1]]);
  }
}


// FIXME: not pretty, refactor possible?
proc computeHumanValue(m : monkey, match : int) : int {
  var valSubtree : monkey;
  var humnSubtree : monkey;

  //writeln();
  //writeln("m = ", m, ", match = ", match);

  if m.op == operation.value {
    if m.name == "humn" then return match;
    else {
      writeln("ERROR: shouldn't get here");
      return -1;
    }

  } else {
    var op0 = m.operands[0];
    var op1 = m.operands[1];
    if dependsOnHuman(monkeyState[op1]) {
      valSubtree = monkeyState[op0];
      humnSubtree = monkeyState[op1];
    } else {
      valSubtree = monkeyState[op1];
      humnSubtree = monkeyState[op0];
    }
    //writeln("valSubtree = ", valSubtree);
    //writeln("humnSubtree = ", humnSubtree);

    if m.name=="root" {
      //writeln("at root, computeValue(valSubtree) = ", computeValue(valSubtree));
      return computeHumanValue(humnSubtree, computeValue(valSubtree));
    
    } else {

      select m.op {
        when operation.mult { // newmatch*computeValue(valSubtree) = match
          //writeln("match/computeValue(valSubtree) = ", match/computeValue(valSubtree));
          return computeHumanValue(humnSubtree, match/computeValue(valSubtree));
        }
        when operation.add {
          //writeln("match-computeValue(valSubtree) = ", match-computeValue(valSubtree));
          return computeHumanValue(humnSubtree, match-computeValue(valSubtree));
        }
        when operation.divide {
          if dependsOnHuman(monkeyState[op0]) { // newmatch/computeValue(valSubtree) = match
            //writeln("match*computeValue(valSubtree) = ", match*computeValue(valSubtree));
            return computeHumanValue(humnSubtree, match*computeValue(valSubtree));
          } else {                              // computeValue(valSubtree)/newmatch = match
            //writeln("computeValue(valSubtree)/match = ", computeValue(valSubtree)/match);
            return computeHumanValue(humnSubtree, computeValue(valSubtree)/match);
          }
        }

        when operation.subtract {
          if dependsOnHuman(monkeyState[op0]) { // newmatch - computeValue(valSubtree) = match
            //writeln("match+computeValue(valSubtree) = ", match+computeValue(valSubtree));
            return computeHumanValue(humnSubtree, match+computeValue(valSubtree));
          } else {                              // computeValue(valSubtree)-newmatch = match
            //writeln("computeValue(valSubtree)-match = ", computeValue(valSubtree)-match);
            return computeHumanValue(humnSubtree, computeValue(valSubtree)-match);
          }
        }
        otherwise return 0;
      }
    }
  }
}  
