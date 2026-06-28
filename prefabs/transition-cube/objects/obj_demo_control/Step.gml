timer += 1;

// A short beat after rm_a appears, rotate the cube across to rm_b via the cube
// transition. Calls the public wrapper, which drives the inherited engine.
if (room == rm_a && timer == 20) {
    room_goto_transition_cube(rm_b, 1.8);
}
