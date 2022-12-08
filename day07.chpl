/*
   day07, directory tree

   usage:
    chpl day07.chpl
    ./day06< input06a.txt

    looked up
https://chapel-lang.org/docs/language/spec/data-parallelism.html?highlight=loop%20expression#forall-expressions
*/
use IO, List;

// The directory tree will be stored with DirNode instances.
// Each node represents a directory.
class DirNode {
  var name : string;
  var fileSizes : int;
  var parent : borrowed DirNode?;
  var dirs : list(owned DirNode);
  var subtreeSize : int;
}

var dirTree = new DirNode("/",0,nil,new list(owned DirNode),0);
var currNode : borrowed DirNode? = dirTree;
var line : string;
const notFound = -1;    // constant returned by string.find() if not found
while readLine(line) {
  var dirname : string;
  var filename : string;
  var filesize : int;

  // FIXME: it would be cleaner to use split in a lot of the below
  if line.find("$ cd")>notFound {
    dirname = line[5..line.size-2];
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
    } else { } // the cd into root, we already created root

  } else if line.find("$ ls")>notFound {

  } else if line.find("dir")>notFound {
    dirname = line[4..line.size-2];
    currNode!.dirs.append(
          new DirNode(dirname,0,currNode!,new list(owned DirNode),0));

  } else { // have a file
    var i=0;
    var filesizeStr : string;
    while line[i].isDigit() {
      filesizeStr += line[i];
      i+=1;
    }
    filesize = filesizeStr : int;
    filename = line[i+1..line.size-2];
    currNode!.fileSizes += filesize;
  }
}

param maxSize = 100000;
// For each directory computing the total subdirectory size
// and storing it in the .subtreeSize field.
// Only returning the sum of all directory sizes less than maxSize.
proc computeSize(dir : borrowed DirNode) : int {
  // sum up all sizes of subdirs
  dir.subtreeSize = dir.fileSizes;
  var total = 0;
  // only sum up those that are less than maxSize
  for subdir in dir.dirs {
    total += computeSize(subdir);
    dir.subtreeSize += subdir.subtreeSize;
  }
  if dir.subtreeSize <= maxSize { return total + dir.subtreeSize; }
  else { return total; }
}
writeln("answer = ", computeSize(dirTree));

// for the second part find the size of the file just big enough
// to give us the unused space needed
const availSpace = 70000000 - dirTree.subtreeSize;
const unusedSpaceNeeded = 30000000-availSpace;

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
