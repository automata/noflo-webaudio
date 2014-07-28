noflo = require 'noflo'

class Play extends noflo.Component
  description: 'Plays given chains and patterns'
  icon: 'play'
  constructor: ->
    @audionodes = []
    @old_audionodes = []
    if (!window.nofloWebAudioContext)
      context = new AudioContext() if AudioContext?
      context = new webkitAudioContext() if webkitAudioContext?
      window.nofloWebAudioContext = context
    @context = window.nofloWebAudioContext

    @inPorts =
      audionodes: new noflo.ArrayPort 'object'

    @inPorts.audionodes.on 'data', (audionodes, i) =>
      @audionodes[i] = audionodes
      # Walks just on current i-th arrayport
      if @audionodes[i] instanceof Array
        @walk @audionodes[i], 0
      else
        @walk [@audionodes[i]], 0
      #@old_audionodes = @audionodes

  # Recursively walk through the AudioNodes' graph and connect them
  walk: (audionodes, level) =>
    for audionode in audionodes
      created = @create audionode
      # Connect top-level AudioNodes to destination
      if level is 0
        created.connect @context.destination
      if audionode.audionodes?
        # Has children? 
        children = audionode.audionodes
        if children instanceof Array
          @walk(children, level+1).connect created
        else
          @walk([children], level+1).connect created
      else
        # Is child?
        return created

  exists: (audionode) =>
    return false

  create: (audionode) =>
    return @parse audionode
    # if not @exists(audionode)
    #   return audionode
    # return audionode

  # noflo-canvas legacy
  parse: (commands) =>
    return unless @context
    @parseThing commands

  # Recursively parse things and arrays of things
  parseThing: (thing, before, after) =>
    if thing? and thing.type? and @[thing.type]?
      if before?
        before()
      return @[thing.type](thing)
      if after?
        after()
    else if thing instanceof Array
      for item in thing
        continue unless item?
        @parseThing item, before, after

  # Instructions (AudioNodes)
  gain: (params) =>
    audioNode = @context.createGain()
    audioNode.gain.value = params.gain
    return audioNode

  oscillator: (params) =>
    waveforms =
      sine: 0
      square: 1
      sawtooth: 2
      triangle: 3
    waveform_num = waveforms[params.waveform]
    audioNode = @context.createOscillator()
    audioNode.type = waveform_num
    audioNode.frequency.value = params.frequency
    return audioNode

exports.getComponent = -> new Play