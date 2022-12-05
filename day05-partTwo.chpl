/*
   day05-partTwo

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
// For part two the crane can do all of a mult-crate
// move at once.  So need a temporary stack to store
// things to reflect that new ordering.
var num, from, to : int;
while readf("move %i from %i to %i\n", num, from, to) {
  var tempList : list(string);
  for count in 1..num {
    tempList.append(crateStacks[from].pop());
  }
  for count in 1..num {
    crateStacks[to].append(tempList.pop());
  }
}

var topOfStacks : string;
for stack in crateStacks {
  topOfStacks += stack.pop();
}
writeln("topOfStacks = ", topOfStacks);


