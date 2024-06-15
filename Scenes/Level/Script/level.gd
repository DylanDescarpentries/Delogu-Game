extends Node2D

const launcher = "res://Scenes/Launcher/Launcher.tscn"

# Called when the node enters the scene tree for the first time.
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var screen_size = Vector2(screen_width, screen_height)
@onready var asteroid_container = $Asteroids
@onready var border_rect = %BorderRect
@onready var game_over = %GameOver
@onready var game_won_layer = $GameWonLayer
@onready var video_stream_player = %VideoStreamPlayer
@onready var audio_stream = $AudioStreamPlayer2D




@export var asteroid_scene : PackedScene
@export var spawn_cirle_radius :float = 350.0
@export var asteroid_direction_variant: float = 45.0 


func _ready():
	EVENTS.connect("score_changed", Callable(self, "_on_EVENTS_nb_score_changed"))
	game_over.hide()
	game_won_layer.hide()

func spawn_asteroid() -> void:
	var screen_center = screen_size / 2
	var angle = deg_to_rad(randf_range(0.0, 360.0))
	
	var dir_to_point = Vector2.RIGHT.rotated(angle)
	var point = screen_center + dir_to_point * spawn_cirle_radius
	
	var top_left = border_rect.global_position
	var bottom_right = border_rect.global_position + border_rect.size
	point = point.clamp(top_left, bottom_right)
	var asteroid = asteroid_scene.instantiate()
	asteroid_container.add_child(asteroid)
	
	var dir_to_center = point.direction_to(screen_center)
	var dir_rotation = randfn(0.0, deg_to_rad(asteroid_direction_variant))
	asteroid.direction = dir_to_center.rotated(dir_rotation)
	asteroid.position = point
	asteroid.size = randi_range(0, Asteroid.SIZE.size() -1)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_asteroid()


func _on_spawn_timer_timeout():
	spawn_asteroid()


func _on_retry_button_pressed():
	get_tree().reload_current_scene()
	GAME.score_reset()


func _on_player_destroyed():
	game_over.show()

func _on_EVENTS_nb_score_changed(nb_score: int, nb_score_faf: int) -> void:
	if nb_score >= 48700000:
		game_won_layer.show()
		video_stream_player.play()
		audio_stream.stop()

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file(launcher)
