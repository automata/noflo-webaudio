noflo = require 'noflo'

{WebAudio} = require '../lib/WebAudio'

class Oscillator extends WebAudio
  constructor: ->
    

exports.getComponent = -> new Oscillator
