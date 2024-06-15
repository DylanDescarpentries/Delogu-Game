extends CharacterBody2D
class_name Player


@export_range(0.0, 1.0) var accel_factor: float = 0.1
@export_range(0.0, 1.0) var rotation_accel_factor: float = 0.1
@export var max_speed: float = 400.0

@export var projectile_scene: PackedScene
@export var projectile_kick_scene: PackedScene

signal projectile_fired(projectile)
signal projectile_kick_fired(projectile_kick)
signal destroyed

var speed: float = 0.0
var direction:= Vector2.ZERO
var last_direction:= Vector2.ZERO

func _ready() -> void:
	var texte: String = "On ready !"
	print(texte)

func _physics_process(_delta: float) -> void:
	_move()
	_rotate_toward_mouse()
	
func _input(event: InputEvent) -> void:
	# Update direction based on input
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction !=Vector2.ZERO:
		last_direction = direction
	
	if event.is_action_pressed("fire"):
		_fire()
	
	if event.is_action_pressed("foot"):
		_kick()

func _fire() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.transform = global_transform
	projectile_fired.emit(projectile)

func _kick() -> void:
	var projectile_kick = projectile_kick_scene.instantiate()
	projectile_kick.transform = global_transform
	projectile_fired.emit(projectile_kick)

func _move() -> void:
	# Update velocity based on direction and max_speed
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, 0.1)
	else:
		speed = lerp(speed, max_speed, accel_factor)
		
	velocity = last_direction * speed
	move_and_slide()

func _rotate_toward_mouse() -> void:
	# Rotate the player towards the mouse position
	var mouse_pos = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse_pos)
	rotation = lerp_angle(rotation, angle, rotation_accel_factor)

func destroy() -> void:
	destroyed.emit()
	queue_free()
