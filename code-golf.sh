#!/usr/bin/env node
"use strict"
const fs = require("fs")
const spawn = require('child_process').spawn
const path = require("path")
const assert = require("assert")

let args = process.argv
let file = args[2]
if (!file) {
    console.log("Must provide file as first argument")
    process.exit(1)
}

let runtime = getRuntime(file)

test(runtime, file).then(() => {
    let stat = fs.statSync(file)
    console.log(`Your score is ${stat.size}`)
    process.exit(0)
}).catch((e) => {
    console.error(e.message || e)
    process.exit(1)
})

function test(runtime, file) {
    return runTest(runtime, file, "games/game-01.txt", "o", [5])
        .then(() => runTest(runtime, file, "games/game-02.txt", "o", [2]))
        .then(() => runTest(runtime, file, "games/game-03.txt", "x", [2]))
        .then(() => runTest(runtime, file, "games/game-04.txt", "o", [5]))
        .then(() => runTest(runtime, file, "games/game-05.txt", "x", [3, 7]))
        .then(() => runTest(runtime, file, "games/game-06.txt", "o", [2]))
        .then(() => runTest(runtime, file, "games/game-07.txt", "x", [1]))
        .then(() => runTest(runtime, file, "games/game-08.txt", "x", [2]))
}

function runTest(runtime, file, inputFile, player, possibleOutput) {
    return new Promise((resolve, reject) => {
        let input = fs.readFileSync(inputFile, "utf-8")

        let errors = []
        let timeout = setTimeout(function () {
            reject("Timeout\n" + errors.join("\n"))
        }, 7000)
        let node
        if (runtime === "dotnet") {
            node = spawn("dotnet", ["script", file, "--", player])
        } else {
            node = spawn(runtime, [file, player])
        }
        node.stdout.setEncoding('utf8')
        node.stdout.on("data", (data) => {
            try {
                clearTimeout(timeout)
                makeAssertions(input, player, possibleOutput, data)
                resolve("file passed tests")
            } catch (e) {
                reject(e);
            }
        })

        node.stderr.on("data", (data) => {
            errors.push(data)
            reject(errors.join("\n"))
        })

        node.stdin.write(input)
        node.stdin.end()
    })
}

function makeAssertions(input, player, possibleOutput, output) {
    // Trim trailing newline
    output = parseInt(output.replace(/\r?\n?$/, ""), 10)
    assert(possibleOutput.includes(output), `The incorrect column was selected.

${" ".repeat(output - 1)}↓
1234567
${input}


Player:   ${player}
Expected: ${possibleOutput.join(" or ")}
Actual:   ${output}`)
}

function getRuntime(file) {
    let extension = path.extname(file)
    switch (extension) {
        case ".js":
            return "node"
        case ".py":
            return "python3"
        case ".rb":
            return "ruby"
        case ".csx":
            return "dotnet"
        default:
            throw new Error("Unrecognized file type")
    }
}