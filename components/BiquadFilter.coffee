noflo = require 'noflo'

{WebAudio} = require '../lib/WebAudio'

class Biquad extends WebAudio
  description: 'biquad filter'
  icon: 'music'
  constructor: ->
    super()
    @audioNode = @context.createBiquadFilter()

    @inPorts =
      audio: new noflo.Port('object'),
      type: new noflo.Port('string'),
      frequency: new noflo.Port('object'),
      q: new noflo.Port('object'),
      gain: new noflo.Port('object'),
      detune: new noflo.Port('object')

    @outPorts =
      audio: new noflo.Port('object')

    @inPorts.audio.on 'data', (inAudio) =>
      @passAudio(inAudio)
    @inPorts.type.on 'data', (data) =>
      @setType(data)
    @inPorts.frequency.on 'data', (data) =>
      @setFrequency(data)
    @inPorts.q.on 'data', (data) =>
      @setQ(data)
    @inPorts.gain.on 'data', (data) =>
      @setGain(data)
    @inPorts.detune.on 'data', (data) =>
      @setDetune(data)

    @passAudio = (inAudio) =>
      # Got an object, lets pass to the next node
      if @outPorts.audio.isAttached()
        inAudio.connect(@audioNode)
        @outPorts.audio.send @audioNode

    @setType = (data) =>
      @audioNode.type.value = data

    @setFrequency = (data) =>
      if  (typeof data is 'string')
        @audioNode.frequency.value = data
      else if (typeof data is 'object')
        data.connect(@audioNode.frequency)

    @setGain = (data) =>
      if  (typeof data is 'string')
        @audioNode.gain.value = data
      else if (typeof data is 'object')
        data.connect(@audioNode.gain)

    @setQ = (data) =>
      if  (typeof data is 'string')
        @audioNode.Q.value = data
      else if (typeof data is 'object')
        data.connect(@audioNode.Q)

    @setDetune = (data) =>
      if  (typeof data is 'string')
        @audioNode.detune.value = data
      else if (typeof data is 'object')
        data.connect(@audioNode.detune)

exports.getComponent = -> new LowPass
