extends Node

signal actor_directions(direction_vector)
signal undo_started()
signal _lock_started(value)

# Signals relating to input

# warning-ignore:unused_signal
signal actor_commands_started()
# warning-ignore:unused_signal
signal actor_commands_finished()
# warning-ignore:unused_signal
signal actor_generated(index)
# warning-ignore:unused_signal
signal actor_duplicated(actor)


# warning-ignore:unused_signal
signal actor_index_update_requested(actor, current_index, new_index)
# warning-ignore:unused_signal
signal actor_index_update_granted(actor, new_position)


# Signal relating to the level class

# warning-ignore:unused_signal
signal level_restarted(starting_index)