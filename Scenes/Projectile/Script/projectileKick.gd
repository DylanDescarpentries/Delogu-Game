extends Area2D

@export var speed: float = 400.0
@onready var direction:= Vector2.RIGHT.rotated(rotation)
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

# Called when the node enters the scene tree for the first time.

func _physics_process(delta: float) -> void:
	var velocity = direction * speed * delta
	global_position += velocity

func _on_area_entered(area):
	if area is Asteroid:
		area.cry()
		queue_free()
