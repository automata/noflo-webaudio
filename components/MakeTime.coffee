noflo = require 'noflo'
{Primative} = require '../lib/Primative'

# FIXME: Should be a Primative?
class MakeTime extends Primative
  description: 'Creates one or more time events'
  icon: 'clock-o'
  constructor: ->
    ports =
      time:
        datatype: 'number'
        description: 'when in future (ms)'
      offset:
        datatype: 'number'
        description: 'distance from start (ms)'
      duration:
        datatype: 'number'
        description: 'how long (ms)'

    super 'time', ports

exports.getComponent = -> new MakeTime
