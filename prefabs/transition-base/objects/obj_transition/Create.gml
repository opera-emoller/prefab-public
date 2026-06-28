// Generic room-transition driver. Created by transition_engine().
// Captures the outgoing room into from_surface, switches rooms, captures the
// incoming room into to_surface, then composites the two through `shader`.

// Size the capture surfaces to the application surface's BACKING BUFFER, not
// application_get_position() — that returns the on-screen/canvas display rect
// (window-relative), which on the wasm/HTML5 build is scaled by the browser and
// does NOT match the resolution the room actually renders at. The room draws
// into these surfaces at application_surface's buffer resolution, so match it.
screen_width = surface_get_width(application_surface);
screen_height = surface_get_height(application_surface);

from_surface = surface_create(screen_width, screen_height);
to_surface = surface_create(screen_width, screen_height);

t = 0.0;                 // elapsed time in seconds
target_room = -1;        // set by transition_engine()
shader = -1;             // set by transition_engine()
fade_length = 2.0;       // total duration in seconds (overridden by caller)
in_target = false;       // false until the outgoing room has been captured
