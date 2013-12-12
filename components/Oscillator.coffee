noflo = require 'noflo'

{WebAudio} = require '../lib/WebAudio'

class Oscillator extends WebAudio
  constructor: ->

    @inPorts =
      audio: new noflo.Port 'object',
      start: new noflo.Port 'object',
      stop: new noflo.Port 'object',
      type: new noflo.Port 'object',
      frequency: new noflo.Port 'object',
      detune: new noflo.Port 'object'

    @outPorts =
      audio: new noflo.Port 'object'

    @inPorts.audio.on 'data', @syncGraph
    @inPorts.audio.on 'disconnect', @unsyncGraph
    @inPorts.start.on 'data', @start
    @inPorts.stop.on 'data', @stop
    @inPorts.type.on 'data', @setType
    @inPorts.frequency.on 'data', @setFrequency
    @inPorts.detune.on 'data', @setDetune

  syncGraph: (data) ->
    if @outPorts.audio.isAttached()
      @outPorts.audio.send @audioOutput
      
  unsyncGraph: (data) ->
    if @outPorts.audio.isAttached()
      @outPorts.audio.disconnect()

  start: (data) ->
    oscNode = @audioOutput = window.nofloWebAudioContext.createOscillator()
    oscNode.frequency.value = 440
    oscNode.detune.value = 0
    oscNode.type = 'sine'
    oscNode.start 0

  stop: (data) ->
    @audioOutput.stop 0
    @audioOutput = null

  setType: (data) ->
    @audioOutput.type = data

  setFrequency: (data) ->
    @audioOutput.frequency.value = data

  setDetune: (data) ->
    @audioOutput.detune.value = data
            

exports.getComponent = -> new Oscillator
