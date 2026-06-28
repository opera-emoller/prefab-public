timer += 1;

// A short beat after rm_a appears, dissolve across to rm_b via the dreamy
// transition. Calls the public wrapper, which drives the inherited engine.
if (room == rm_a && timer == 20) {
    room_goto_transition_dreamy(rm_b, 1.8);
}
