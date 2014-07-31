noflo = require 'noflo'
{Primative} = require '../lib/Primative'

class Panner extends Primative
  description: 'Changes the location of a given audio source'
  icon: 'compass'
  constructor: ->
    ports =
      audionodes:
        datatype: 'object'
        description: 'audio nodes (oscillators, buffer sources, ...)'
        addressable: true
        required: true
      position:
        datatyle: 'object'
        description: 'a 2D or 3D point'
        required: true

    super 'panner', ports

exports.getComponent = -> new Panner
