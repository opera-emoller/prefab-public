#version 300 es
precision highp float;

// Cube room transition: the outgoing room (from_tex) and the incoming room
// (to_tex) are mapped onto the faces of a rotating 3D cube, with a soft floor
// reflection of both faces, as progress goes 0 -> 1.
//
// Ported from the monolith's shdr_cube (gl-transitions' Cube by gre, MIT) to
// GLSL ES 3.00. Drives transition-base's shader-agnostic engine: the engine
// drives `progress`, binds the outgoing room to texture stage 0 and the
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

// Cube parameters. The monolith exposed these as uniforms with these defaults;
// transition-base's engine only drives progress/from_tex/to_tex, so they are
// baked in here as constants.
const float persp = 0.7;
const float unzoom = 0.3;
const float reflection = 0.4;
const float floating = 3.0;

vec2 project(vec2 p) {
    return p * vec2(1.0, -1.2) + vec2(0.0, -floating / 100.0);
}

bool inBounds(vec2 p) {
    return all(lessThan(vec2(0.0), p)) && all(lessThan(p, vec2(1.0)));
}

vec4 bgColor(vec2 p, vec2 pfr, vec2 pto) {
    vec4 c = vec4(0.0, 0.0, 0.0, 1.0);
    pfr = project(pfr);
    if (inBounds(pfr)) {
        c += mix(vec4(0.0), getFromColor(pfr), reflection * mix(1.0, 0.0, pfr.y));
    }
    pto = project(pto);
    if (inBounds(pto)) {
        c += mix(vec4(0.0), getToColor(pto), reflection * mix(1.0, 0.0, pto.y));
    }
    return c;
}

// p      : the position
// persp  : the perspective in [ 0, 1 ]
// center : the xcenter in [0, 1] \ 0.5 excluded
vec2 xskew(vec2 p, float persp, float center) {
    float x = mix(p.x, 1.0 - p.x, center);
    return (
        (
            vec2(x, (p.y - 0.5 * (1.0 - persp) * x) / (1.0 + (persp - 1.0) * x))
            - vec2(0.5 - distance(center, 0.5), 0.0)
        )
        * vec2(0.5 / distance(center, 0.5) * (center < 0.5 ? 1.0 : -1.0), 1.0)
        + vec2(center < 0.5 ? 0.0 : 1.0, 0.0)
    );
}

vec4 transition(vec2 op) {
    float uz = unzoom * 2.0 * (0.5 - distance(0.5, progress));
    vec2 p = -uz * 0.5 + (1.0 + uz) * op;
    vec2 fromP = xskew(
        (p - vec2(progress, 0.0)) / vec2(1.0 - progress, 1.0),
        1.0 - mix(progress, 0.0, persp),
        0.0
    );
    vec2 toP = xskew(
        p / vec2(progress, 1.0),
        mix(pow(progress, 2.0), 1.0, persp),
        1.0
    );
    if (inBounds(fromP)) {
        return getFromColor(fromP);
    } else if (inBounds(toP)) {
        return getToColor(toP);
    }
    return bgColor(op, fromP, toP);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
