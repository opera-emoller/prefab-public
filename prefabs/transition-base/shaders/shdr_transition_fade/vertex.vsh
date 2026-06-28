#version 300 es

// The transition engine draws a fullscreen quad directly in clip space
// (draw_vertex_texture with -1..1 coordinates), so the position passes
// straight through without applying the projection matrix.
in vec3 in_Position;
in vec2 in_TextureCoord;

out vec2 v_vTexcoord;

void main() {
    gl_Position = vec4(in_Position.xy, 0.0, 1.0);
    v_vTexcoord = in_TextureCoord;
}
