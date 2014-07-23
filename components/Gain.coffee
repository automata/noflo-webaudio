noflo = require 'noflo'
{Primative} = require '../lib/Primative'

class Gain extends Primative
  description: 'Multiplies the input audio signal by the given gain value, ' +
               'changing its amplitude.'
  icon: 'music'
  constructor: ->
    ports =
      audionodes:
        datatype: 'object'
        description: 'audio nodes (oscillators, buffer sources, ...)'
        addressable: true
      gain:
        datatyle: 'number'
        description: 'amount of gain to apply (0...1)'
        required: false

    super 'gain', ports

exports.getComponent = -> new Gain
