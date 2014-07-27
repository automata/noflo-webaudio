noflo = require 'noflo'
{Primative} = require '../lib/Primative'

class Oscillator extends Primative
  description: 'Create an audio source with a periodic waveform ' +
               '(sine, square, sawtooth, triangle, custom)'
  icon: 'volume-up'
  constructor: ->
    ports =
      waveform:
        datatype: 'string'
        description: 'sine, square, sawtooth, triangle, custom'
        required: true
      frequency:
        datatype: 'number'
        description: 'frequency of signal'
        required: true

    super 'oscillator', ports

exports.getComponent = -> new Oscillator
