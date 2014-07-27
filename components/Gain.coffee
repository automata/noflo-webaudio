noflo = require 'noflo'
{Primative} = require '../lib/Primative'

class Gain extends Primative
  description: 'Multiplies the input audio signal by the given gain value, ' +
               'changing its amplitude.'
  icon: 'filter'
  constructor: ->
    ports =
      audionodes:
        datatype: 'object'
        description: 'audio nodes (oscillators, buffer sources, ...)'
        addressable: true
        required: true
      gain:
        datatyle: 'number'
        description: 'amount of gain to apply (0...1)'
        required: true

    super 'gain', ports

exports.getComponent = -> new Gain
