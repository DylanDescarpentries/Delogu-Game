extends Node

@onready var score_count = $Score/ScoreCount
@onready var faf_count = $Score/FafCount

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("score_changed", Callable(self, "_on_EVENTS_nb_score_changed"))


func _on_EVENTS_nb_score_changed(nb_score: int, nb_faf_score: int) -> void:
	if nb_faf_score <=0:
		nb_faf_score = 0
		nb_score >= nb_faf_score
	score_count.set_text("Front Populaire : " + str(nb_score) + " Votant.es")
	faf_count.set_text("Facho: " + str(nb_faf_score) +" Votant.es")
