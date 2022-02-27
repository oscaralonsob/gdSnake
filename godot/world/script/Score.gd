extends Node2D


onready var screen_size = get_viewport().size


func _ready():
	$ScoreText.rect_position = Vector2(screen_size.x - 100, screen_size.y - 40)
	EventBus.connect("update_score_signal", self, "update_score")
	update_score(2)


func update_score(snake_length: int) -> void:
	$ScoreText.text = str("Score: ", snake_length)
