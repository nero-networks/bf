#!/usr/bin/env coffee
fs = require 'fs'

## read the code from file
code = fs.readFileSync(process.argv[2]).toString()

## init some variables
reg = [0]   ## registers; first initialized, auto growing
ptr = 0     ## register pointer
mrk = 0     ## loop index marker
idx = 0;    ## code index

## map of known code characters to interpreter commands
cmd =
    '>': -> reg[++ptr] ?= 0         # move to the next register
    '<': -> ptr = 0 if --ptr < 0    # move to the previous register
    '+': -> reg[ptr]++              # increment the current register
    '-': -> reg[ptr]--              # decrement the current register
    '.': -> write reg[ptr]          # print register value as a char
    ',': -> reg[ptr] = read()       # read char code into the current register
    '[': -> mrk = idx               # start loop
    ']': -> idx = mrk if reg[ptr]   # rewind idx (and loop again) until reg[ptr] is 0

## parser loop. reads the code char by char
## and executes mapped command if available.
## skips all unknown characters (aka code beautyfications)
## ends after the last character was parsed/executed.
run = ()->
    while idx < code.length
        cmd[code.charAt idx++]?()

## helper to read from STDIN
fs = require 'fs'
stdin = fs.openSync('/dev/stdin', 'rs')
read = ->
    c = Buffer.alloc 1
    fs.readSync stdin, c, 0, 1
    return c[0]

## helper to write to STDOUT
write = (c)->
    process.stdout.write String.fromCharCode c

## kick off the parser loop.
run()
