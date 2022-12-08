# adventOfCode2022

## Programming concepts and Chapel features used

day01, calorie count
* reading in lines from standard input, Daniel provided code snippet in slack
```
  for line in stdin.lines() {
    const trimmedLine = line.strip();
```
* string: strip and string comparison
* control flow: for loop, if, else if, else
* writeln

day02, rock paper scissors
* map: declaring, adding elements with `[]` operator, reading elements with `[]`
* tuple: used as a key into the dictionary
* string: indexing into a string

day03, rucksacks
* defining functions
* string.byte() method for getting the unicode(?) value for a character
* set
  * part A: declaration `var firstHalf : set(uint(8));`, add method, contains method
  * part B: intersection with `&` operator, clear method
* range: `numHalf..<line.size`
* array of sets: `var rucksack : [0..<3] set(uint(8));`,

day04, ranges
* solution1: readf, control flow
* solution2: ranges
* solution3: iterator, forall with reduce intents
* I wrote blog post

day05, crates
* iterator to create arrays
* array of lists, using lists like stacks
* zippered iteration
* readf

day06, subsets to find message marker
* domain
* sets
* forall
* separate reduction

day07, directory tree
* classes
* lists
* recursion

## Log

day01, calorie count
* started at 10pm MST
* finished both at 10:48
* got hung up on readLine to int cast bug, Jeremiah fixed it!!
  https://github.com/chapel-lang/chapel/pull/21146
* and then did an icky first approach to the second part


day02, rock paper scissors
* started the next morning
* took about 45 minutes to do both


day03, rucksacks
* did first one in about 40 minutes
* second one took about 30 minutes

day04, ranges
* this was my fastest one at 22 minutes for the first one and then another 13 minutes for 2nd
* I wrote a blog post for this one that took about 12 hours

day05, crate stacks
* I really struggled with this one because I was avoiding readLine.
  I ended up using most of Brad's answer.

day06
* The two combined took me 45 minutes.
* I learned more about scans and reduces.
* The result is really fast

day07, directory tree
* took two hours, about half reading in the input and about half solving the problems
