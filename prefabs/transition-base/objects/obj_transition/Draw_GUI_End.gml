surface_reset_target();

if (in_target) {
    // Both rooms captured: composite them through the transition shader.
    if (surface_exists(from_surface) && surface_exists(to_surface)) {
        shader_set(shader);

        texture_set_stage(0, surface_get_texture(from_surface));
        texture_set_stage(1, surface_get_texture(to_surface));
        shader_set_uniform_i(shader_get_uniform(shader, "from_tex"), 0);
        shader_set_uniform_i(shader_get_uniform(shader, "to_tex"), 1);
        shader_set_uniform_f(shader_get_uniform(shader, "progress"), clamp(t / fade_length, 0, 1));

        // Fullscreen quad in clip space (-1..1); the vertex shader is a passthrough.
        draw_primitive_begin(pr_trianglestrip);
        draw_vertex_texture(-1, -1, 0, 0);
        draw_vertex_texture( 1, -1, 1, 0);
        draw_vertex_texture(-1,  1, 0, 1);
        draw_vertex_texture( 1,  1, 1, 1);
        draw_primitive_end();

        shader_reset();
    }
} else {
    // First frame: the outgoing room is now in from_surface; switch rooms.
    in_target = true; //gmx-lint-ignore draw-event-mutation
    room_goto(target_room);
}
