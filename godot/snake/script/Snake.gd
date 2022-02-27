extends Node
class_name Snake


const SNAKE = 0

# I don't really like this but i have no idea how to do it rn
onready var snake_world = get_node("../SnakeWorld")
var snake_body_origin: Array =  [Vector2(2,2), Vector2(2,1)]
var snake_body: Array = snake_body_origin
var snake_head: Vector2 = snake_body[0]
var snake_direction: Vector2 = Vector2.RIGHT
var _grow_snake: bool = false


func _ready() -> void:
	EventBus.connect("apple_eaten_signal", self, "_grow_snake")


func draw() -> void:
	for snake_part in snake_body:
		snake_world.set_cell(snake_part.x, snake_part.y, SNAKE)


func _input(event):
	if Input.is_action_just_pressed("ui_up") and snake_direction != Vector2.DOWN:
		snake_direction = Vector2.UP
	
	if Input.is_action_just_pressed("ui_right") and snake_direction != Vector2.LEFT:
		snake_direction = Vector2.RIGHT
	
	if Input.is_action_just_pressed("ui_left") and snake_direction != Vector2.RIGHT:
		snake_direction = Vector2.LEFT
	
	if Input.is_action_just_pressed("ui_down") and snake_direction != Vector2.UP:
		snake_direction = Vector2.DOWN


func move() -> void:
	var remove_body_parts: int = 1 if _grow_snake else 2
	var new_snake_body: Array
	new_snake_body = snake_body.slice(0, snake_body.size() - remove_body_parts)
	
	new_snake_body.insert(0, new_snake_body[0] + snake_direction)
	snake_body = new_snake_body
	_grow_snake = false
	snake_head = snake_body[0]


func reset() -> void:
	snake_body = snake_body_origin
	snake_direction = Vector2.RIGHT


func is_outside_map() -> bool:
	return snake_head.x > 30 or snake_head.x < 0 or snake_head.y > 30 or snake_head.y < 0#TODO: snake_world.GAME_SIZE


func is_eating_itself() -> bool:
	for part in snake_body.slice(1, snake_body.size() -1):
		if part == snake_head:
			return true
			
	return false


func _grow_snake() -> void:
	_grow_snake = true
