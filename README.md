Code Golf: Hole 4
===========================

## Introduction

Code Golf is a competition where given a programming prompt, the shortest source code (measured in bytes) to fully implement the prompt wins the challenge. Ties are broken by the first golfer to submit a solution of a given size.

## Challenge

Your friend Jake is writing a [Connect Four](https://en.wikipedia.org/wiki/Connect_Four) clone. The game is almost complete, but he needs your help with the computer opponent. He wants you to write a program that picks the winning move, and he wants it to be small and fast!

He gives you the state of the game board through stdin. He also provides you the next disc (`o` or `x`) as the first argument. He wants your program to print the column where dropping the next disc will win the game.

```bash
$ cat games/game-01.txt | node my-solution.js 'o'
5
$ cat games/game-02.txt | python3 my-solution.py 'o'
2
$ cat games/game-03.txt | ruby my-solution.rb 'x'
2
$ cat games/game-04.txt | dotnet script my-solution.csx -- 'o'
5
```

## Rules

* The languages are limited to JavaScript (Node.js 6.9), Python3 (3.6), Ruby (2.4), and C# ([.NET Core 1.1](https://github.com/filipw/dotnet-script)).
* Your submission is limited to a single file.
* The game board is provided through stdin, one row per line.
  * The game board is 7 columns wide and 6 rows tall
  * The board has 4 valid characters:
    * `.` is an empty cell
    * `x` is a red disc
    * `o` is a blue disc
    * `\n` is a new row
* The next disc is provided as the first argument, `x` for a red disc, `o` for a blue disc.
* Your program must print a single number
  * The number equals the column where dropping a disc results in a winning move.
  * The columns are indexed 1-7 from left to right.
  * A winning move results in 4 of the same color disc in a vertical, horizontal, or diagonal line.

## Scoring

Please submit a single file (.js, .py, .rb, or .csx). The included node script `code-golf.sh` will be used to score your file. To run this script, you must have Node.js installed.

macOS
```bash
$ ./code-golf.sh my-solution.js
Your score is 456
```

Windows
```
C:\> node code-golf.sh my-solution.js
Your score is 456
```

Docker
```bash
$ docker build -t golf .
$ docker run -it -v "$PWD":/tmp/src golf bash
$ ./code-golf.sh my-solution.js
Your score is 456
```

![golf](https://media.giphy.com/media/13fTigyJHlacwM/giphy.gif)
