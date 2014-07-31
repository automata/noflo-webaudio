noflo = require 'noflo'
Tuna = require '../vendor/tuna.js'

class Play extends noflo.Component
  description: 'Plays given chains and patterns'
  icon: 'play'
  constructor: ->
    @audionodes = []
    @table_audionodes = {}
    if (!window.nofloWebAudioContext)
      context = new AudioContext() if AudioContext?
      context = new webkitAudioContext() if webkitAudioContext?
      window.nofloWebAudioContext = context
    @context = window.nofloWebAudioContext
    @tuna = new Tuna(@context)

    @inPorts =
      audionodes: new noflo.ArrayPort 'object'

    @inPorts.audionodes.on 'data', (audionodes, i) =>
      @audionodes[i] = audionodes
      # Walks just on current i-th arrayport
      if @audionodes[i] instanceof Array
        @walk @audionodes[i], 0
      else
        @walk [@audionodes[i]], 0

  # Recursively walk through the AudioNodes' graph and connect them
  walk: (audionodes, level) =>
    console.log audionodes, level
    for audionode in audionodes
      created = @create audionode
      # Connect top-level AudioNodes to destination
      if level is 0
        created.connect @context.destination
      if audionode.audionodes?
        # Has children?
        children = audionode.audionodes
        console.log 'connect to', created
        if children instanceof Array
          @walk(children, level+1).connect created
        else
          @walk([children], level+1).connect created
      else
        # Is child?
        console.log 'connect from', created
        return created

  create: (audionode) =>
    return @parse audionode

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
    # For now update/create is almost the same, we should improve this ASAP
    # so we can get off this selection and to do specific things for each case
    if params.id of @table_audionodes
      audioNode = @table_audionodes[params.id]
    else
      audioNode = @context.createGain()
      @table_audionodes[params.id] = audioNode
    audioNode.gain.value = params.gain
    return audioNode

  oscillator: (params) =>
    if params.id of @table_audionodes
      audioNode = @table_audionodes[params.id]
    else
      audioNode = @context.createOscillator()
      # FIXME: How to deal with start?
      audioNode.start params.start
      @table_audionodes[params.id] = audioNode
    waveforms =
      sine: 0
      square: 1
      sawtooth: 2
      triangle: 3
    waveform_num = waveforms[params.waveform]
    
    audioNode.type = waveform_num
    audioNode.frequency.value = params.frequency
    #audioNode.start params.start
    return audioNode

  panner: (params) =>
    if params.id of @table_audionodes
      audioNode = @table_audionodes[params.id]
    else
      audioNode = @context.createPanner()
      @table_audionodes[params.id] = audioNode
    # FIXME: Just 2D for now to interoperate with noflo-canvas
    audioNode.setPosition(params.position.x, params.position.y, 0)
    return audioNode

  audiofile: (params) =>
    if params.id of @table_audionodes
      audioNode = @table_audionodes[params.id]
    else
      audioNode = @context.createBufferSource()
      audioNode.buffer = @data
      #audioNode.connect(audioContext.destination)
      #audioNode.start(audioContext.currentTime, offset, duration)
      @table_audionodes[params.id] = audioNode

exports.getComponent = -> new Play