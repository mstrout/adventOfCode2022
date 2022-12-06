// https://chapel-lang.org/docs/language/spec/data-parallelism.html?highlight=loop%20expression#forall-expressions
use IO, Set;

var line : string;
readLine(line);

//writeln(line);

// use a domain!
config var subsetSize = 4;
//writeln(subsetSize);
var searchDomain = {subsetSize-1..<line.size};
//writeln("searchDomain = ", searchDomain);
var uniqueSubsetIdx : [searchDomain] int; 
forall i in searchDomain {
  var charSet : set(string);
  for j in 0..<subsetSize {
    //writeln("(i,j) = ", (i,j));
    //writeln("line[i-h] = ", line[i-j]);
    charSet.add(line[i-j]);
  }
  //writeln(charSet);
  if charSet.size==subsetSize {
    uniqueSubsetIdx[i] = i+1; // they want 1 indexing on characters
  } else {
    uniqueSubsetIdx[i] = searchDomain.size;
  }
}
//writeln(uniqueSubsetIdx);
writeln( min reduce uniqueSubsetIdx );

/*
var test = [1,2,3,4,5,4,3]; //56783";

writeln(min scan test);
writeln(max scan test);
writeln(+ scan test);
*/
