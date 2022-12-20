// day 20, mix
use IO;

iter readInput() {
  var num : int;
  var count : int;
  while readf("%i", num) {
    yield(count,num);
    count += 1;
  }
}

var input = readInput();

//writeln(input);

var curr = 0;
while curr<input.size {
  //writeln();
  //writeln("curr = ", curr);
  var idx, pos, val : int;
  // search through to find what we should be currently moving
  for (i,(p,v)) in zip(input.domain,input) {
    if p==curr {
      idx = i; // FIXME: that these don't go out of loop is confusing
      pos = p;
      val = v;
      break;
    }
  }
  //writeln("idx = ", idx, ", pos = ", pos, ", val = ", val);
  // find target location
  var targetIdx = calcTargetIndex(val, idx);
  //if val < 0 && idx<=abs(val) { // wrap around to left
  //  targetIdx = (idx + val + input.size-1) % input.size;
  //} else if val>0 && (idx+val)>=input.size { // wrap around to right
  //  targetIdx = (idx + val + 1) % input.size;
  //} else {
  //  targetIdx = (idx + val) % input.size;
  //}
  //writeln("after call: targetIdx = ", targetIdx);
  // put the (pos,val) pair in target by swapping with everyone before then
  if idx<targetIdx {
    for i in idx..<targetIdx {
      input[i] <=> input[i+1];
    }
  } else {
    for i in targetIdx..<idx by -1 {
      input[i] <=> input[i+1];
    }
  }
  curr += 1;
  //writeln(input);
}
//writeln(input);

// find the zero value
var zeroIdx : int;
while input[zeroIdx][1]!=0 {
  zeroIdx +=1;
}
//writeln("zeroIdx = ", zeroIdx);

writeln("calcTargetIndex(4,10)-1 should equal 0, ", calcTargetIndex(4,10)-1);
writeln("calcTargetIndex(4,18)-1 should equal 1, ", calcTargetIndex(4,18)-1);
writeln("calcTargetIndex(5,4) should equal 3, ", calcTargetIndex(5,4));

var first = input[calcTargetIndex(1000,zeroIdx)-1][1],
    second = input[calcTargetIndex(2000,zeroIdx)-1][1],
    third = input[calcTargetIndex(3000,zeroIdx)-1][1];
writeln("1000 past zero = ", first);
writeln("2000 past zero = ", second);
writeln("3000 past zero = ", third);

writeln("anwer = ", first+second+third);

proc calcTargetIndex(val, idx : int) {
  var targetIdx : int;
  if val < 0 && idx<=abs(val) { // wrap around to left
    //targetIdx = (idx + val + input.size -1*(1+val/input.size)) % input.size;
    var toBegin = idx;
    var mod = (abs(val)-toBegin) % input.size;
    targetIdx = if mod>1 then input.size-mod-1 else 0;
    //targetIdx = input.size-1 - ((abs(val) - toBegin)%input.size);
    writeln("wrap left: targetIdx = ", targetIdx);
  } else if val>0 && (idx+val)>=input.size { // wrap around to right
    //targetIdx = (idx + val + 1*(1+val/input.size)) % input.size;
    var toEnd = input.size - idx;
    targetIdx = (val-toEnd) % input.size + 1;
    writeln("wrap right: targetIdx = ", targetIdx);
  } else {
    targetIdx = (idx + val) % input.size;
  }
  return targetIdx;
}
