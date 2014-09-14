noflo = require 'noflo'
Tuna = require '../vendor/tuna.js'

class Play extends noflo.Component
  description: 'Plays given chains and patterns'
  icon: 'play'
  constructor: ->
    @audionodes = []
    @table_audionodes = {}
    @buffer_data = {}
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
      # update
      # A bit different, we always create a new buffer source
      audioNode = @context.createBufferSource()
      @table_audionodes[params.id] = audioNode
      # Update the buffer data
      if @buffer_data[params.id]?
        @updateBuffer(audioNode, params.id)
        # Plays only on update
        audioNode.start params.start.time, params.start.offset, params.start.duration
    else
      # create
      audioNode = @context.createBufferSource()
      @table_audionodes[params.id] = audioNode
      # XHR downloads and loads only at node creation
      request = new XMLHttpRequest()
      request.open("GET", params.file, true)
      request.responseType = "arraybuffer"
      request.onload = () =>
        @context.decodeAudioData request.response, (buffer) =>
          @buffer_data[params.id] = buffer
          # FIXME: Should we blink the component, how to do that from here?
          @updateBuffer(audioNode, params.id)
      request.send()

    return audioNode

  updateBuffer: (audionode, id) =>
    audionode.buffer = @buffer_data[id]

exports.getComponent = -> new Play