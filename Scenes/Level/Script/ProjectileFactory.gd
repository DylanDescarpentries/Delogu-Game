extends Node2D

func spawn_projectile(projectile) -> void:
	add_child(projectile)


func _on_player_projectile_fired(projectile):
	spawn_projectile(projectile)

func spawn_projectile_kick(projectile_kick) -> void:
	add_child(projectile_kick)

func _on_player_projectile_kick_fired(projectile_kick):
	spawn_projectile(projectile_kick)
