/// Cube room transition — public API.
///
/// A linked variant of transition-base: it reuses the inherited, shader-agnostic
/// `transition_engine` (from `scr_transition_base`) and simply drives it with the
/// cube shader. The engine captures the outgoing and incoming rooms to surfaces
/// and composites them through `shdr_transition_cube`, advancing a 0 -> 1
/// `progress` uniform over `duration` seconds.
///
/// @param {Asset.GMRoom} target_room  The room to transition to.
/// @param {Real}         duration     Transition length in seconds.

#export room_goto_transition_cube;
function room_goto_transition_cube(target_room, duration) {
    return transition_engine(target_room, shdr_transition_cube, duration);
}
