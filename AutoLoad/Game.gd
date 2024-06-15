extends Node

var incr: int = 1
var nb_fafs = 48700000
var nb_score: int = 0:
	set(value):
		if value >= nb_fafs:
			nb_score = nb_fafs
			EVENTS.emit_signal("score_changed", nb_score, nb_faf_score)
		elif value != nb_score:
			nb_score = value
			EVENTS.emit_signal("score_changed", nb_score, nb_faf_score)

var nb_faf_score: int = nb_fafs:
	set(value):
		if value != nb_faf_score:
			nb_faf_score = value
			EVENTS.emit_signal("score_changed", nb_faf_score, nb_score)

func _ready():
	EVENTS.connect("score_add", Callable(self, "_on_score_add"))

func _on_score_add() -> void:                                                  
	nb_faf_score -= incr
	nb_score += incr
	if nb_score >= nb_fafs:
		nb_score = nb_fafs
	if incr > 1:
		incr += incr
	else:
		incr += 1
	EVENTS.emit_signal("score_changed", nb_score, nb_faf_score)

func score_reset() -> void:
	nb_faf_score = nb_fafs
	nb_score = 0
	incr = 1
	EVENTS.emit_signal("score_changed", nb_score, nb_faf_score)
