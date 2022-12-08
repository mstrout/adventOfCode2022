/*
   day06

   usage:
    chpl day06.chpl
    ./day06< input06a.txt

    looked up
https://chapel-lang.org/docs/language/spec/data-parallelism.html?highlight=loop%20expression#forall-expressions
*/
use IO, Set;

config var subsetSize = 4;

var line : string;
readLine(line);

// uniqueSubsetIdx[i] will be set to i if the subsetSize characters
// before i in the input are unique and line.size othersize.
// This way we can do a min reduction on uniqueSubsetIdx to get the answer.
var searchDomain = {subsetSize-1..<line.size};
var uniqueSubsetIdx : [searchDomain] int; 
forall i in searchDomain {
  var charSet : set(string);
  for j in 0..<subsetSize {
    charSet.add(line[i-j]);
  }
  if charSet.size==subsetSize {
    uniqueSubsetIdx[i] = i+1; // they want 1 indexing on characters
  } else {
    uniqueSubsetIdx[i] = searchDomain.size;
  }
}
writeln( min reduce uniqueSubsetIdx );
