
Bf = (io)->

    # init some variables
    reg = [0]   ## registers; first initialized, auto growing
    ptr = 0     ## register pointer
    mrk = 0     ## loop index marker
    idx = 0;    ## code index

    # map of known code characters to interpreter commands
    cmd =
        '>': -> reg[++ptr] ?= 0             # move to the next register
        '<': -> ptr = 0 if --ptr < 0        # move to the previous register
        '+': -> reg[ptr]++                  # increment the current register
        '-': -> reg[ptr]--                  # decrement the current register
        '.': -> io?.write? reg[ptr]         # print register value as a char
        ',': -> reg[ptr] = io?.read?() || 0 # read char code into the current register
        '[': -> mrk = idx                   # start loop
        ']': -> idx = mrk if reg[ptr]       # rewind idx (and loop again) until reg[ptr] is 0

    # parser loop. reads the code char by char
    # and executes mapped command if available.
    # skips all unknown characters (aka code beautyfications)
    # ends after the last character was parsed/executed.
    run: (code)->
        idx = 0
        while idx < code.length
            cmd[code.charAt idx++]?()
        return # prevents cs compiler to fill and return useless arrays

    reset: ()->
        reg = [ptr = mrk = 0]

module.exports = Bf if typeof module is 'object'
