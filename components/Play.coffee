noflo = require 'noflo'

class Play extends noflo.Component
  description: 'Plays given chains and patterns'
  icon: 'music'
  constructor: ->
    @commands = []
    if (!window.nofloWebAudioContext)
      context = new AudioContext() if AudioContext?
      context = new webkitAudioContext() if webkitAudioContext?
      window.nofloWebAudioContext = context
    @context = window.nofloWebAudioContext

    @inPorts =
      commands: new noflo.ArrayPort 'object'

    @inPorts.commands.on 'data', (commands, i) =>
      @commands[i] = commands
      @parse @commands

  parse: (commands) =>
    return unless @context
    @parseThing commands
    console.log 'PARSE', commands

  # Recursively parse things and arrays of things
  parseThing: (thing, before, after) =>
    if thing? and thing.type? and @[thing.type]?
      if before?
        before()
      @[thing.type](thing)
      if after?
        after()
    else if thing instanceof Array
      for item in thing
        continue unless item?
        @parseThing item, before, after

  # Instructions
  gain: (gain) =>
    _gain = @context.createGain()
    if gain.gain?
      _gain.gain = gain.gain
    for node in gain.audionodes
      _audioNode = @context.createOscillator()
      _audioNode.type = node.waveform
      _audioNode.frequency = node.frequency
      _audioNode.connect _gain
    _gain.connect @context.destination
    console.log 'GAIN', gain

exports.getComponent = -> new Play