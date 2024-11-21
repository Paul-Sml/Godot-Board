extends Resource
class_name PawnResource

#Board position
var tile: Tile
var boardX: int
var boardY: int
var boardXY: Vector2i

enum pawnOwner {PLAYER, PLAYER2, ENVIRONEMENT, MONSTER, NONE}

@export_group("ID")
@export var name: String
@export_multiline var description: String
@export var image: Texture2D

@export_group("properties")
@export var owner: pawnOwner = pawnOwner.PLAYER
@export var occupiesTile: bool = true

func newPos(newTile: Tile) -> void:
	return setNewPositionOnBoard(newTile)
func setNewPositionOnBoard(newTile: Tile) -> void:
	tile = newTile
	boardX = newTile.boardX
	boardY = newTile.boardY
	boardXY = newTile.boardXY

func setOccupiesTile(occupies: bool) -> void:
	occupiesTile = occupies

func setOwner(newOwner: pawnOwner) -> void:
	owner = newOwner

func getTile() -> Tile:
	return tile
