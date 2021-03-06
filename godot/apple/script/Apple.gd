extends Node
class_name Apple

const APPLE = 1


# I don't really like this but i have no idea how to do it rn
onready var snake_world = get_node("../SnakeWorld")
var apple_pos: Vector2 = Vector2(0,0)


func _ready() -> void:
	EventBus.connect("apple_eaten_signal", self, "place")



# Place the apple elsewhere and draw it
func update_position() -> void:
	place()
	draw()


# Choose a random place where the apple will be placed
func place() -> void:
	randomize()
	var x: int = randi() % snake_world.GAME_SIZE
	var y: int = randi() % snake_world.GAME_SIZE
	apple_pos = Vector2(x, y)


# Set the cell on the tile map with the correct sprite
func draw() -> void:
	snake_world.set_cell(apple_pos.x, apple_pos.y, APPLE)
