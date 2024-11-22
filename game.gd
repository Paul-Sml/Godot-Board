extends Control
const tileSize: Vector2 = Vector2(80,80)

var mainBoard: Board = Board.new(9,9, true, tileSize)
var sideBoard1: Board = Board.new(1,9, true, tileSize)
var sideBoard2: Board = Board.new(1,9, true, tileSize)

var hoveredTile: Tile

const NEW_RESOURCE = preload("res://Assets/new_resource.tres")

func _ready() -> void:
	self.add_child(mainBoard)
	self.add_child(sideBoard1)
	self.add_child(sideBoard2)
	
	#Connect Boards' signals to game functions
	mainBoard.move.connect(move)
	mainBoard.outsideMove.connect(moveToAnotherBoard)
	sideBoard1.outsideMove.connect(moveToAnotherBoard)
	sideBoard2.outsideMove.connect(moveToAnotherBoard)
	
	mainBoard.getTile(4,4).placeNodeOnTile(Pawn.new(NEW_RESOURCE))
	
	sideBoard1.position.x = -600
	sideBoard2.position.x = 520

func move(startingTile: Tile, endingTile: Tile) -> void:
	mainBoard.movePawnAction(startingTile,endingTile)

func moveToAnotherBoard(startingTile: Tile) -> void:
	var pawn = startingTile.getPawnOnTile()
	if pawn != null:
		startingTile.removeNodeOnTile(pawn)
		hoveredTile.placeNodeOnTile(pawn)
