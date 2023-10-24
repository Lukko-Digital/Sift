extends Node

# Dialogue
signal alert_dialogue
signal idle_dialogue
signal enter_dialogue(npc_node)
signal advance_dialogue
signal interaction_complete(npc_node, branch)
signal dialogue_complete

# Combat UI
signal player_damaged(damage)

# World Vars
signal set_world_var(key, val)
signal increment_world_var(key, val)
