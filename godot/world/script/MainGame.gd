extends Node


const BG    = 2


onready var apple: Apple = $Apple
onready var snake: Snake = $Snake


func _ready():
	clear_background()
	apple.place()
	apple.draw()
	snake.draw()
	EventBus.emit_signal("update_score_signal", snake.snake_body.size())


# Updates all cell with the background sprite
func clear_background() -> void:
	var i: int = 0
	while i <= $SnakeWorld.GAME_SIZE:
		var j: int =  0
		while j <= $SnakeWorld.GAME_SIZE:
			$SnakeWorld.set_cell(i, j, BG)
			j += 1
		i += 1


# Checks if the apple has been eaten
func check_apple_eaten() -> void:
	if snake.snake_head == apple.apple_pos:
		EventBus.emit_signal("apple_eaten_signal")
		EventBus.emit_signal("update_score_signal", snake.snake_body.size() + 1)


# Check the faliure states
func check_game_over() -> void:
	if snake.is_outside_map() || snake.is_eating_itself():
		snake.reset();
		EventBus.emit_signal("update_score_signal", snake.snake_body.size() + 1)


# Every 0.2s we "move" the snake
func _on_Timer_timeout():
	clear_background()
	snake.move()
	check_apple_eaten()
	check_game_over()
	apple.draw()
	snake.draw()
