extends Control
var mainBoard: Board = Board.new(9,9, false, Vector2(50,50))
const NEW_RESOURCE = preload("res://Assets/new_resource.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_child(mainBoard)
	mainBoard.getTile(0,0).placeNodeOnTile(Pawn.new(NEW_RESOURCE))
