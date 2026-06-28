t += delta_time / 1000000;

if (t > fade_length) {
    if (surface_exists(from_surface)) surface_free(from_surface);
    if (surface_exists(to_surface)) surface_free(to_surface);
    instance_destroy();
    global.active_transition = -1;
}
