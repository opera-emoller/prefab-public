timer += 1;

// A short beat after rm_a appears, fade across to rm_b.
if (room == rm_a && timer == 20) {
    transition_engine(rm_b, shdr_transition_fade, 1.8);
}
