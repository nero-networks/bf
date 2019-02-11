
class Bf

    #
    constructor: (io)->
        @reset()

        # map of known code characters to interpreter commands
        @cmd =
            '>': => @reg[++@ptr] ?= 0                # move to the next register
            '<': => @ptr = 0 if --@ptr < 0           # move to the previous register
            '+': => @reg[@ptr]++                     # increment the current register
            '-': => @reg[@ptr]--                     # decrement the current register
            '.': => io?.write? @reg[@ptr]            # print register value as a char
            ',': => @reg[ptr] = io?.read?() || 0     # read char code into the current register
            '[': => @mrk.push @idx                   # start loop
            ']': => # rewind idx (and loop again) until reg[ptr] is 0
                if @reg[@ptr] then @idx = @mrk[@mrk.length - 1] else @mrk.pop()

    # parser loop. reads the code char by char
    # and executes mapped command if available.
    # skips all unknown characters (aka code beautyfications)
    # ends after the last character was parsed/executed.
    run: (code)->
        @idx = 0
        while @idx < code.length
            @cmd[code.charAt @idx++]?()
        return # prevents cs compiler to fill and return useless arrays

    # (re)init some variables
    reset: ()->
        @mrk = []
        @reg = [@ptr = 0]

module.exports = Bf if typeof module is 'object'
