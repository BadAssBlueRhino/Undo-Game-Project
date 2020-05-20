extends Node

# Signals relating to input

# warning-ignore:unused_signal
signal direction_key_pressed(direction)
# warning-ignore:unused_signal
signal trigger_locked_group(is_triggered)
# warning-ignore:unused_signal
signal undo_action_signaled(event)
# warning-ignore:unused_signal
signal gui_restart_pressed()

# Signals relating to the actors/cube class

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