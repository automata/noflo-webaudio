noflo = require 'noflo'
        
class exports.WebAudio extends noflo.Component

  constructor: () ->
    if (!window.nofloWebAudioContext)
      context = new AudioContext() if AudioContext?
      context = new webkitAudioContext() if webkitAudioContext?
      window.nofloWebAudioContext = context
    @context = window.nofloWebAudioContext        

        
