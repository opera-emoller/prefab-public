# Transition Cube

A rotating-cube room-transition for GameMaker — a linked variant of
[`transition-base`](https://github.com/opera-emoller/prefab-public/tree/main/prefabs/transition-base).

It inherits the shader-agnostic `transition_engine` and its driver object from
the base, and ships only its own wrapper script and shader:

```gml
room_goto_transition_cube(rm_next, 1.8); // rotate the cube to rm_next over 1.8s
```

The included demo (`rm_a` -> `rm_b`) shows the Swedish blue -> yellow cube
rotation; the demo rooms and control object are scaffolding and are not exported.
