noflo = require 'noflo'
{Primative} = require '../lib/Primative'

class Oscillator extends Primative
  description: 'Create an audio source with a periodic waveform ' +
               '(sine, square, sawtooth, triangle, custom)'
  icon: 'music'
  constructor: ->
    ports =
      waveform:
        datatype: 'string'
        description: 'sine, square, sawtooth, triangle, custom'
        required: false
      frequency:
        datatype: 'number'
        description: 'frequency of signal'
        required: false

    super 'oscillator', ports

exports.getComponent = -> new Oscillator
