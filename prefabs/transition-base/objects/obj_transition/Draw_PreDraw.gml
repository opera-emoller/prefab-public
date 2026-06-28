// Redirect this frame's rendering into a surface: the outgoing room into
// from_surface, then (once captured) the incoming room into to_surface.
if (in_target) {
    if (!surface_exists(to_surface)) to_surface = surface_create(screen_width, screen_height);
    surface_set_target(to_surface);
} else {
    if (!surface_exists(from_surface)) from_surface = surface_create(screen_width, screen_height);
    surface_set_target(from_surface);
}
