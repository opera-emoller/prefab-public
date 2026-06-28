/**
 * Generic shader-driven room transition engine.
 *
 * This is the INTERNAL engine that the transition-base library exposes through
 * `obj_transition`. It is deliberately shader-agnostic: callers pass the shader
 * to drive, so variant prefabs can build on this base without porting any
 * effect-specific switch logic.
 *
 * The engine spawns a persistent `obj_transition`, which:
 *   1. captures the outgoing room into a surface,
 *   2. `room_goto`s the target room and captures it into a second surface,
 *   3. composites the two through `shader`, advancing a 0 -> 1 `progress`
 *      uniform over `duration` seconds,
 *   4. tears itself down when the transition completes.
 *
 * The shader must expose the uniforms `from_tex` (sampler), `to_tex` (sampler)
 * and `progress` (float). Texture stage 0 is the outgoing room, stage 1 the
 * incoming room.
 *
 * If a transition is already running, the call is ignored.
 *
 * Example:
 *   transition_engine(rm_level2, shdr_transition_fade, 1.5);
 *
 * @param {Asset.GMRoom}   target_room  The room to transition to.
 * @param {Asset.GMShader} shader       The transition shader to drive.
 * @param {Real}           duration     Transition length in seconds.
 */
function transition_engine(target_room, shader, duration) {
    if (!variable_global_exists("active_transition") || global.active_transition == -1) {
        global.active_transition = instance_create_depth(0, 0, 0, obj_transition);
        global.active_transition.target_room = target_room;
        global.active_transition.shader = shader;
        global.active_transition.fade_length = duration;
    }
}
