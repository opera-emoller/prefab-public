#version 300 es
precision highp float;

// Dreamy room transition: a wavy, dreamlike cross-dissolve. As progress goes
// 0 -> 1 the outgoing room (from_tex) drifts and wobbles vertically while the
// incoming room (to_tex) wobbles in from the opposite phase, and the two are
// mixed by progress.
//
// Ported from the monolith's shdr_dreamy (gl-transitions' Dreamy by mikolalysenko,
// MIT) to GLSL ES 3.00. Drives transition-base's shader-agnostic engine: the
// engine drives `progress`, binds the outgoing room to texture stage 0 and the
// incoming room to stage 1, and this shader composites them.

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

vec2 offset(float p, float x, float theta) {
    float phase = p * p + p + theta;
    float shifty = 0.03 * p * cos(10.0 * (p + x));
    return vec2(0.0, shifty);
}

vec4 transition(vec2 p) {
    return mix(
        getFromColor(p + offset(progress, p.x, 0.0)),
        getToColor(p + offset(1.0 - progress, p.x, 3.14)),
        progress
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
