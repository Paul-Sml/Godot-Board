extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var instance = Board.new(9,9, false)
	self.add_child(instance)
	pass # Replace with function body.
