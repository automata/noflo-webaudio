noflo = require 'noflo'

{WebAudio} = require '../lib/WebAudio'

class Gain extends WebAudio
  description: 'gain filter'
  icon: 'music'
  constructor: ->
    super()
    @audioNode = @context.createGain()

    @inPorts =
      audio: new noflo.Port('object'),
      gain: new noflo.Port('number')

    @outPorts =
      audio: new noflo.Port('object')

    @inPorts.audio.on 'data', (inAudio) =>
      @passAudio(inAudio)
    @inPorts.gain.on 'data', (gainValue) =>
      @setGain(gainValue)

    @passAudio = (inAudio) =>
      # Got an object, lets pass to the next node
      inAudio.connect(@audioNode)
      if @outPorts.audio.isAttached()
        @outPorts.audio.send @audioNode

    @setGain = (gainValue) =>
      @audioNode.gain.value = gainValue


exports.getComponent = -> new Gain
