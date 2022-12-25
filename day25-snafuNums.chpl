// day25-snafuNums
use IO, Map;

iter readLines() {
  var line : string;
  while readLine(line) {
    yield line.strip();
  }
}

var numArray = readLines();

writeln(numArray);

var snafuToDecimal : map(string,int);
snafuToDecimal["1"] = 1;
snafuToDecimal["2"] = 2;
snafuToDecimal["0"] = 0;
snafuToDecimal["-"] = -1;
snafuToDecimal["="] = -2;

// converting snafuToDecimal
var decVal : [numArray.domain] int;
for (idx,str) in zip(numArray.domain,numArray) {
  decVal[idx] = 0;
  var placeVal = 1;
  for i in 0..#str.size by -1 {
    decVal[idx] += placeVal*snafuToDecimal[str[i]];
    placeVal *= 5;
  }
  writeln("decVal[idx] = ", decVal[idx]);
}
const sum = + reduce decVal;
writeln("sum = ", + reduce decVal);

// converting decimal to snafu
//for n in decVal { // this was for testing
// FIXME: need to refactor most of below into a function
// and turn into a do while loop

  var str = "";
  var num = sum;        // <====================
  var numMod5 = num%5;
  var numDiv5 = num/5;
  while numDiv5>0 || numMod5>0 {
    select numMod5 {
      when 2 { str = "2" + str; }
      when 1 { str = "1" + str; }
      when 0 { str = "0" + str; }
      when 3 { str = "=" + str; num += 5; }
      when 4 { str = "-" + str; num += 5; }
      otherwise { writeln("ERROR"); }
    }
    num = (num - numMod5)/5;
    numMod5 = num%5;
    numDiv5 = num/5;
  }
  writeln("str = ", str);
//}
