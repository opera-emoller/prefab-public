#version 300 es
precision highp float;

// Cross-fade room transition: linearly blends the outgoing room (from_tex)
// into the incoming room (to_tex) as progress goes 0 -> 1.
//
// Ported from the monolith's shdr_fade (gl-transitions' fade, MIT) to
// GLSL ES 3.00. This is transition-base's default, shader-agnostic effect:
// the engine drives `progress`; variants can swap in any shader sharing
// these uniform names.

uniform sampler2D from_tex;   // outgoing room, bound to texture stage 0
uniform sampler2D to_tex;     // incoming room, bound to texture stage 1
uniform float progress;       // 0 -> 1 over the transition

in vec2 v_vTexcoord;
out vec4 frag_colour;

// Surfaces are stored top-down, so flip v when sampling.
vec4 getToColor(vec2 uv) {
    return texture(to_tex, vec2(uv.x, 1.0 - uv.y));
}

vec4 getFromColor(vec2 uv) {
    return texture(from_tex, vec2(uv.x, 1.0 - uv.y));
}

vec4 transition(vec2 uv) {
    return mix(getFromColor(uv), getToColor(uv), progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
