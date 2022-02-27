extends Node


const SNAKE = 0
const APPLE = 1
const BG    = 2
const GAME_SIZE = 30

onready var apple: Apple = $Apple
onready var snake: Snake = $Snake


func _ready():
	clear_background()
	apple.place()
	apple.draw()
	snake.draw()
	EventBus.emit_signal("update_score_signal", snake.snake_body.size())


func clear_background() -> void:
	var i: int = 0
	while i <= GAME_SIZE:
		var j: int =  0
		while j <= GAME_SIZE:
			$SnakeWorld.set_cell(i, j, BG)
			j += 1
		i += 1


func check_apple_eaten() -> void:
	if snake.snake_head == apple.apple_pos:
		EventBus.emit_signal("apple_eaten_signal")
		EventBus.emit_signal("update_score_signal", snake.snake_body.size() + 1)


func check_game_over() -> void:
	if snake.is_outside_map() || snake.is_eating_itself():
		snake.reset();
		EventBus.emit_signal("update_score_signal", snake.snake_body.size() + 1)


func _on_Timer_timeout():
	clear_background()
	snake.move()
	check_apple_eaten()
	check_game_over()
	apple.draw()
	snake.draw()
