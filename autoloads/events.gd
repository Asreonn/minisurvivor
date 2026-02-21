extends Node

# Player
signal player_damaged(amount: float)
signal player_died()
signal player_healed(amount: float)

# XP / Leveling
signal xp_gained(amount: int)
signal level_up(new_level: int)
signal skill_chosen(skill_id: String)

# Graze
signal graze_triggered()
signal overcharge_started()
signal overcharge_ended()

# Enemies
signal enemy_killed(enemy: Node2D, position: Vector2)
signal enemy_spawned(enemy: Node2D)

# Skills
signal skill_activated(skill_id: String)
signal skill_upgraded(skill_id: String, new_level: int)
signal modifier_added(modifier_id: String, skill_id: String)

# Game flow
signal game_started()
signal game_over(survived_time: float)
signal wave_changed(wave_index: int)

# UI
signal show_level_up_menu(choices: Array)
signal level_up_menu_closed()

# FX
signal screen_flash(color: Color, duration: float)
signal camera_shake(intensity: float, duration: float)
