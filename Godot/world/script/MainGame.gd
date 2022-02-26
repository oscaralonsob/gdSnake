extends Node


const SNAKE = 0
const APPLE = 1
const BG    = 2
var apple_pos: Vector2 = Vector2(0,0)
var snake_pos_origin: Array =  [Vector2(2,2), Vector2(2,1)]
var snake_pos: Array = snake_pos_origin
var snake_direction: Vector2 = Vector2.RIGHT
var grow_snake: bool = false


func _ready():
	apple_pos = place_apple()
	draw_apple()
	draw_snake()
	EventBus.emit_signal("update_score_signal", snake_pos.size())


func _input(event):
	if Input.is_action_just_pressed("ui_up") and snake_direction != Vector2.DOWN:
		snake_direction = Vector2.UP
	
	if Input.is_action_just_pressed("ui_right") and snake_direction != Vector2.LEFT:
		snake_direction = Vector2.RIGHT
	
	if Input.is_action_just_pressed("ui_left") and snake_direction != Vector2.RIGHT:
		snake_direction = Vector2.LEFT
	
	if Input.is_action_just_pressed("ui_down") and snake_direction != Vector2.UP:
		snake_direction = Vector2.DOWN


func place_apple() -> Vector2:
	randomize()
	var x: int = randi() % 10
	var y: int = randi() % 10
	return Vector2(x, y)


func draw_apple() -> void:
	$SnakeWorld.set_cell(apple_pos.x, apple_pos.y, APPLE)


func draw_snake() -> void:
	for snake_part in snake_pos:
		$SnakeWorld.set_cell(snake_part.x, snake_part.y, SNAKE)


func clear_background() -> void:
	var i: int = 0
	while i <= 12:
		var j: int =  0
		while j <= 12:
			$SnakeWorld.set_cell(i, j, BG)
			j += 1
		i += 1


func move_snake() -> void:
	var remove_body_parts: int = 1 if grow_snake else 2
	var new_snake_pos: Array
	new_snake_pos = snake_pos.slice(0, snake_pos.size() - remove_body_parts)
	
	new_snake_pos.insert(0, new_snake_pos[0] + snake_direction)
	snake_pos = new_snake_pos
	grow_snake = false


func apple_eaten() -> void:
	if snake_pos[0] == apple_pos:
		apple_pos = place_apple()
		grow_snake = true
		EventBus.emit_signal("apple_eaten_signal")
		EventBus.emit_signal("update_score_signal", snake_pos.size() + 1)


func check_game_over() -> void:
	var head: Vector2 = snake_pos[0]
	
	if head.x > 12 or head.x < 0 or head.y > 20 or head.y < 0:
		reset();
	
	for part in snake_pos.slice(1, snake_pos.size() -1):
		if part == head:
			reset()


func reset() -> void:
	snake_pos = snake_pos_origin
	snake_direction = Vector2.RIGHT


func _on_Timer_timeout():
	clear_background()
	move_snake()
	apple_eaten()
	check_game_over()
	draw_apple()
	draw_snake()
