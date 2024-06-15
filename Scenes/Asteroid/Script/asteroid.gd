@tool
extends Area2D
class_name Asteroid

@onready var sprite = $Sprite2D
@onready var collision_shape= $CollisionShape2D
@onready var audio_stream = $AudioStreamPlayer2D
@export var asteroid_preset_array: Array[AsteroidPreset]
@export var direction := Vector2.RIGHT
@export var speed: float = 400.0
@export var torque = 50.0
@export var distance_traveled: float = 0.0                              
@export var DESTROY_DISTANCE: float = 500.0 

var has_been_hit = false
signal size_changed

enum SIZE {
	MARINE,
	MACRON,
	MERDELLA,
	MEYER,
}

@export var size: SIZE:
	set(value):
		if value != size:
			size = value
			size_changed.emit()

#### BUILTS-IN####
func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	var velocity = speed * direction * delta
	global_position += velocity
	
	rotation_degrees += torque * delta	
	_asteroid_is_hit(delta) 

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.destroy()

#### ACCESSORS ####

func _on_size_changed():
	assert(size in range(asteroid_preset_array.size()), "The given size " + str(size) + " isn't a valid asteroid Index" )

	var asteroide_size = asteroid_preset_array[size]
	sprite.texture = asteroide_size.texture
	collision_shape.shape = asteroide_size.shape
	audio_stream.stream = asteroide_size.audio_hit

func destroy() -> void:
	EVENTS.emit_signal("score_add")
	direction = -direction
	rotation_degrees = direction.angle() * 180 / PI

	
func cry() -> void:                                                            
	EVENTS.emit_signal("score_add")                                            
	var asteroide_size = asteroid_preset_array[size]                           
	direction = -direction                                                     
	sprite.texture = asteroide_size.texture_hit    
	audio_stream.stream = asteroide_size.audio_hit   
	rotation_degrees = direction.angle() * 180 / PI                            
	speed = 300
	audio_stream.play()                      

func _asteroid_is_hit(delta: float) -> void:
	# Cumuler la distance parcourue uniquement si l'astéroïde a été touché
	if has_been_hit:
		var distance = speed * delta                                            
		distance_traveled += distance                                              
		if distance_traveled >= DESTROY_DISTANCE:
			call_deferred("queue_free")                               
