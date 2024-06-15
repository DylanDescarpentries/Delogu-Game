extends Node2D

var first_level = "res://Scenes/Level/level.tscn"
@onready var canvas_layer = $CanvasLayer
@onready var audio_stream = $AudioStreamPlayer2D

#### SIGNAUX ####
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(first_level)



