/*
   day05

   usage:
    chpl day04-solution1.chpl
    ./day04-solution1 < input04a.txt

   See associated blog post at 
   https://chapel-lang.org/blog/posts/aoc2022-day04-ranges/.
 */
use IO, List;

param charsPerStack = 4; // number of characters per stack in input

// read and yield lines until we get to the blank one
iter readInitState() {
  var line: string;
  while (readLine(line) && line.size > 1) do
    yield line;
}

// Procedure that initializes the crate stacks from the input.
proc initStacks() {
  // array of strings with initial crate stack configuration
  const initState = readInitState();

  // use the last line (with all the stack numbers) to compute the # of stacks
  var numStacks = initState.last.size / charsPerStack;

  // Represent our stacks with an array of lists of strings
  var crateStacks : [1..numStacks] list(string);

  // iterate over the lines representing crates backwards (bottom up),
  // skipping over the line with the stack numbers
  for i in 0..<initState.size-1 by -1 {

    // do a zippered iteration over the stack IDs and
    // offsets where crate names will be
    for (s,off) in zip(1..numStacks, 1.. by charsPerStack) {
      const char = initState[i][off];
      if (char != " ") {  // blank means no crate here
        crateStacks[s].append(char);
      }
    }
  }

  return crateStacks;
}

var crateStacks = initStacks();

// read in and execute all of the move operations
var num, from, to : int;
while readf("move %i from %i to %i\n", num, from, to) {
  for count in 1..num {
    crateStacks[to].append(crateStacks[from].pop());
  }
}

var topOfStacks : string;
for stack in crateStacks {
  topOfStacks += stack.pop();
}
writeln("topOfStacks = ", topOfStacks);

  /*
var line : string;
var linesPastStackConfig = 0; 
for line in stdin.lines() {
  // moving past stack config
  if (linesPastStackConfig==0 && line[1] == "1")
     || (linesPastStackConfig==1) {
    linesPastStackConfig += 1;

  // processing a stack configuration line, each stack is 4 characters,
  // crate is at the second character in each stack
  } else if linesPastStackConfig==0 {
    const numCharsPerStack = 4;
    for i in 1..<(line.size-1) by numCharsPerStack {
      if line[i]!=" " {
        crateStacks[i/numCharsPerStack + 1].insert(0,line[i]);
      }
    }
    //writeln(crateStacks);

  // reading the number of stacks to move from one stack to another
  // move # from # to #, number is at index 5, from is at 12, to at 17
  } else {
    var num = line[5] : int;
    var from = line[12] : int;
    var to = line[17] : int;
    writeln("move ", num, " from ", from, " to ", to);
    for count in 1..num {
      crateStacks[to].append(crateStacks[from].pop());
    }
    //writeln(crateStacks);
  }
}
*/

