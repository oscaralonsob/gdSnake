extends AudioStreamPlayer2D


func _ready():
	EventBus.connect("apple_eaten_signal", self, "_play_sound")


func _play_sound() -> void:
	self.play()
