extends CanvasLayer

@onready var score_label: Label = %Score
@onready var host: Label = %Host

func _ready() -> void:
	if multiplayer.is_server():
		host.text = "Host"

var score = 0:
	set(value):
		score = value
		_update_score_label()
		
func _update_score_label():
	score_label.text = str(score)

func collect() -> void:
	score += 1
