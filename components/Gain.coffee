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
      gain: new noflo.Port('object')

    @outPorts =
      audio: new noflo.Port('object')

    @inPorts.audio.on 'data', (inAudio) =>
      @passAudio(inAudio)
    @inPorts.gain.on 'data', (data) =>
      @setGain(data)

    @passAudio = (inAudio) =>
      # Got an object, lets pass to the next node
      if @outPorts.audio.isAttached()
        inAudio.connect(@audioNode)
        @outPorts.audio.send @audioNode

    @setGain = (data) =>
      if  (typeof data is 'string')
        @audioNode.gain.value = gainValue
      else if (typeof data is 'object')
        data.connect(@audioNode.gain)

exports.getComponent = -> new Gain
