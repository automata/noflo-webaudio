noflo = require 'noflo'

{WebAudio} = require '../lib/WebAudio'

class Destination extends WebAudio
  description: 'audio output'
  icon: 'volume-up'
  constructor: ->
    super()
    @audioNode = @context.destination
  
    @inPorts =
      audio: new noflo.Port()

    @inPorts.audio.on 'data', (inputData) =>
      inputData.connect(@audioNode)

    @inPorts.audio.on 'disconnect', =>


exports.getComponent = -> new Destination
