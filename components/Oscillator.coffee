noflo = require 'noflo'

{WebAudio} = require '../lib/WebAudio'

class Oscillator extends WebAudio
  description: 'oscillator audio source'
  icon: 'music'
  constructor: ->
    super()
    @audioNode = @context.createOscillator()
    @started = false

    @inPorts =
      audio: new noflo.Port('object'),
      start: new noflo.Port('bang'),
      stop: new noflo.Port('bang'),
      type: new noflo.Port('string'),
      frequency: new noflo.Port('object'),
      detune: new noflo.Port('number')

    @outPorts =
      audio: new noflo.Port('object')

    @inPorts.audio.on 'data', (inAudio) =>
      @passAudio(inAudio)
    @inPorts.start.on 'data', =>
      @start()
    @inPorts.stop.on 'data', =>
      @stop()
    @inPorts.type.on 'data', (typeValue) =>
      @setType(typeValue)
    @inPorts.frequency.on 'data', (data) =>
      @setFrequency(data)
    @inPorts.detune.on 'data', (detuneValue) =>
      @setDetune(detuneValue)

    @passAudio = (inAudio) =>
      # Got an object, lets pass to the next node
      if @outPorts.audio.isAttached()
        inAudio.connect(@audioNode)
        @outPorts.audio.send @audioNode

    @start = () =>
      # Lets create and send our audioNode
      if not @started
        if @outPorts.audio.isAttached()
          @audioNode = @context.createOscillator()
          @audioNode.frequency.value = 440
          @audioNode.detune.value = 0
          @audioNode.type = 'sine'
          @outPorts.audio.send @audioNode
          @audioNode.start 0
          @started = true

    @stop = () =>
      if @started
        if @outPorts.audio.isAttached()
          @audioNode.stop 0
          @audioNode.disconnect()
          @outPorts.audio.disconnect()
          @started = false

    @setType = (typeValue) =>
      @audioNode.type = typeValue

    @setFrequency = (data) =>
      # Is it an audio node (e.g. LFO) or a value?
      if (typeof data is 'string')
        @audioNode.frequency.value = data
      else if (typeof data is 'object')
        data.connect(@audioNode.frequency)

    @setDetune = (detuneValue) =>
      @audioNode.detune.value = detuneValue

exports.getComponent = -> new Oscillator
