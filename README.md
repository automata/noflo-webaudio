noflo-webaudio
==============

NoFlo components for Web Audio API.

```
osc -> gain -> play

=> (gain :signal (osc))


osc1 -.-> gain -> play
osc2 -'

=> (gain :signal [(osc1) (osc2)])


osc1 -.-> filter -> gain -> play
osc2 -'

=> (filter :sig (gain :sig [(osc1) (osc2)]))
```