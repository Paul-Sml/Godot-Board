extends Resource
class_name Pawn

#Board position
var boardX: int
var boardY: int
var boardXY: Vector2i

@export_group("hehe")
@export var occupiesTile: bool= true

func setNewPositionOnBoard(x: int, y: int) -> void:
	boardX = x
	boardY = y
	boardXY = Vector2i(x,y)

func setOccupiesTile(occupies: bool) -> void:
	occupiesTile = occupies
