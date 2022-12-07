use IO, List;

class DirNode {
  var name : string;
  var fileSizes : int;
  var parent : borrowed DirNode?;
  var dirs : list(owned DirNode);
  var subtreeSize : int;
}

var done = false;
var line : string;
const notFound = -1;
var dirTree : owned DirNode = new DirNode("/",0,nil,new list(owned DirNode),0);
var currNode : borrowed DirNode? = dirTree;
while readLine(line) {
  var dirname : string;
  var filename : string;
  var filesize : int;

  if line.find("$ cd")>notFound {
    dirname = line[5..line.size-2];
    //writeln("found cd to ", dirname);
    if dirname==".." {
      currNode = currNode!.parent;
    }
    else if dirname!="/" {
      // find directory node and cd into it
      for dir in currNode!.dirs {
        if dir.name == dirname {
          currNode = dir;
          break;
        }
      }
      //writeln("currNode!.name = ", currNode!.name);
    } else {
      writeln("at root");
    }

  } else if line.find("$ ls")>notFound {
    //writeln("found ls");

  } else if line.find("dir")>notFound {
    dirname = line[4..line.size-2];
    //writeln("found dir ", dirname);
    currNode!.dirs.append(
          new DirNode(dirname,0,currNode!,new list(owned DirNode),0));

  } else if line[0].isDigit() {
    var i=0;
    var filesizeStr : string;
    while line[i].isDigit() {
      filesizeStr += line[i];
      i+=1;
    }
    filesize = filesizeStr : int;
    filename = line[i+1..line.size-2];
    //writeln("found file ", filename, " ", filesize);
    currNode!.fileSizes += filesize;
    //writeln("dir ", currNode!.name, ".fileSizes = ", currNode!.fileSizes);
  } else {
    done = true;
    //writeln("EOF");
  }
}

param maxSize = 100000;
proc computeSize(dir : borrowed DirNode) : int {
  //writeln("computeSize on dir ", dir.name, ", dir.dirs.size = ", dir.dirs.size);
  // sum up all sizes of subdirs
  dir.subtreeSize = dir.fileSizes;
  var total = 0;
  // only sum up those that are less than maxSize
  for subdir in dir.dirs {
    total += computeSize(subdir);
    dir.subtreeSize += subdir.subtreeSize;
  }
  //writeln("dir ", dir.name, " has a subtreeSize = ", dir.subtreeSize);
  //writeln("total = ", total);
  if dir.subtreeSize <= maxSize { return total + dir.subtreeSize; }
  else { return total; }
}

writeln("answer = ", computeSize(dirTree));
var availSpace = 70000000 - dirTree.subtreeSize;
writeln("availSpace = ", availSpace);
var unusedSpaceNeeded = 30000000-availSpace;
writeln("unusedSpaceNeeded = ", unusedSpaceNeeded);
proc findBigEnough(dir : borrowed DirNode) : int {
  var currMin = 70000000;
  for subdir in dir.dirs {
    var tmpMin = findBigEnough(subdir);
    if tmpMin<currMin then currMin = tmpMin;
  }
  if (dir.subtreeSize>=unusedSpaceNeeded) && (dir.subtreeSize<currMin) {
    return dir.subtreeSize;
  } else {
    return currMin;
  }
}

writeln("part 2 answer = ", findBigEnough(dirTree));
