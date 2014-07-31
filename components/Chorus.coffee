noflo = require 'noflo'
{Primative} = require '../lib/Primative'

class Chorus extends Primative
  description: 'Basic chorus effect (TUNA)'
  icon: 'group'
  constructor: ->
    ports =
      audionodes:
        datatype: 'object'
        description: 'audio nodes (oscillators, buffer sources, ...)'
        addressable: true
        required: true
      rate:
        datatyle: 'number'
        description: '(0.01...8+)'
        required: true
      feedback:
        datatyle: 'number'
        description: '(0...1+)'
        required: true
      delay:
        datatyle: 'number'
        description: '(0...1)'
        required: true
      bypass:
        datatyle: 'number'
        description: '(0 or 1)'
        required: true

    super 'chorus', ports

exports.getComponent = -> new Chorus
