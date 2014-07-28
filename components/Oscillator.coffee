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
      start:
        datatype: 'number'
        description: 'schedules to playback at an exact time'
      stop:
        datatype: 'number'
        description: 'schedules to stop at an exact time'

    super 'oscillator', ports

exports.getComponent = -> new Oscillator
