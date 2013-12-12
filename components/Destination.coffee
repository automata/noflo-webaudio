noflo = require 'noflo'

{WebAudio} = require '../lib/WebAudio'

class Destination extends WebAudio
  constructor: ->
    @audioInput = window.nofloWebAudioContext.destination

    @inPorts =
      audio: new noflo.Port 'object'

    @inPorts.audio.on 'data', @syncSource
    @inPorts.audio.on 'disconnect', @unsyncSource

  syncSource: (upstream) =>
    return unless upstream
    if @audioOutput
      @audioOutput.connect @audioInput

  unsyncSource: (event) =>

exports.getComponent = -> new Destination
