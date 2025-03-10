extends Control
class_name Board

const TILE = preload("res://Board/Scenes/Tile.tscn")

#Board UI data
var uiCenterOfBoard: Vector2
var tileSize: Vector2
var originalTile: Tile
var hoveredTile: Tile
var moveActive: bool = false
var canHoldItems: bool = true
var multipleBoards: bool

#Board game data
var boardSizeX: int
var boardSizeY: int
var tiles: Array[Tile] = []

##---SIGNALS---

signal move
signal outsideMove


##---INITIALISATION---

func _init(sizeX: int, sizeY: int, areThereMultipleBoards: bool, desiredTileSize: Vector2) -> void:
	self.boardSizeX = sizeX
	self.boardSizeY = sizeY
	self.multipleBoards = areThereMultipleBoards
	self.tileSize = desiredTileSize

func _ready() -> void:
	#Sets the board invisible before  all the setup is ready
	visible = false
	
	createBoard()
	
	#Put the center of the board on 0,0
	uiCenterOfBoard = Vector2(tileSize.x * boardSizeX, tileSize.y * boardSizeY)/2
	self.position -= uiCenterOfBoard
	centerCameraOnBoard()
	
	#Sets the board visible after all the setup is ready
	visible = true

func createBoard() -> void:
	for y in boardSizeY:
		for x in boardSizeX:
			#Instanciate
			var instance: Tile = TILE.instantiate()
			instance.name = instance.name + "_" + str(x) + str(y)
			instance.setBoardPosition(x, y)
			tiles.append(instance)
			self.add_child(instance)
			
			#Size and placement
			instance.setColorRectSize(tileSize)
			instance.position.x = tileSize.x * x
			instance.position.y = tileSize.y * y
			
			#Coloring
			coloringTile(instance, x, y)

#Color tile according to the position. Change to your liking
func coloringTile(instance: Tile, x: int, y: int) -> void:
	if x == (boardSizeX-1) / 2 and y == (boardSizeY-1) / 2:
		instance.setBaseColor(Color.LIGHT_CORAL)
	else : if (x + y) % 2 == 0:
		instance.setBaseColor(Color.LIGHT_BLUE)
	else :
		instance.setBaseColor(Color.ALICE_BLUE)

func centerCameraOnBoard() -> void:
	get_viewport().get_camera_2d().position = self.position + uiCenterOfBoard

##---INTERACTIONS---

##TODO : Better holding
func _gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		originalTile = hoveredTile
		if canHoldItems:
			moveActive = true
		
	if moveActive and canHoldItems:
		if Input.is_action_pressed("Click"):
			pass
		
		if Input.is_action_just_released("Click") and hoveredTile == null and multipleBoards:
			moveActive = false
			outsideMove.emit(originalTile)
		
		if (Input.is_action_just_released("Click") and (originalTile == hoveredTile or (hoveredTile == null and !multipleBoards))) or Input.is_action_just_pressed("RClick"):
			moveActive = false
		
		else : if Input.is_action_just_released("Click"):
			if hoveredTile != null:
				move.emit(originalTile, hoveredTile)
	
	

##---ACTIONS---

func placeNodeOnTile(tilePos: Vector2i, node: Node) -> void:
	getTileVector(tilePos).placeNodeOnTile(node)

func movePawn(startingTile: Tile, endingTile: Tile) -> void:
	var pawn = startingTile.getPawnOnTile()
	if pawn != null:
		startingTile.removeNodeOnTile(pawn)
		endingTile.placeNodeOnTile(pawn)

func movePawnAction(startingTile: Tile, endingTile: Tile) -> void:
	if canMovePawn(startingTile,endingTile):
		movePawn(startingTile,endingTile)

##---GET TILES---

func getTileVector(XY: Vector2i) -> Tile:
	return getTile(XY.x, XY.y)

func getTile(x: int, y: int) -> Tile:
	if x < 0 or x > boardSizeX - 1 or y < 0 or y > boardSizeY - 1:
		return null
	return tiles[x + boardSizeX*y]

func getAllTiles() -> Array[Tile]:
	return tiles

func getAllOtherTiles(tile: Tile) -> Array[Tile]:
	var t: Array[Tile] = tiles
	t.erase(tile)
	return t

func getAllOtherTilesVector(XY: Vector2):
	return getAllOtherTiles(getTileVector(XY))

func getAdjacentTiles(tile: Tile) -> Array[Tile]:
	var t: Array[Tile] = []
	t.append(getTile(tile.boardX+1,tile.boardY))
	t.append(getTile(tile.boardX-1,tile.boardY))
	t.append(getTile(tile.boardX,tile.boardY+1))
	t.append(getTile(tile.boardX,tile.boardY-1))
	t = t.filter(func(i): return i != null)
	return t

func getSurroundingTiles(tile: Tile) -> Array[Tile]:
	var t: Array[Tile] = []
	t.append(getTile(tile.boardX+1,tile.boardY))
	t.append(getTile(tile.boardX-1,tile.boardY))
	t.append(getTile(tile.boardX,tile.boardY+1))
	t.append(getTile(tile.boardX,tile.boardY-1))
	t.append(getTile(tile.boardX+1,tile.boardY+1))
	t.append(getTile(tile.boardX-1,tile.boardY-1))
	t.append(getTile(tile.boardX+1,tile.boardY-1))
	t.append(getTile(tile.boardX-1,tile.boardY+1))
	t = t.filter(func(i): return i != null)
	return t

func getAlignedTiles(tile: Tile) -> Array[Tile]:
	var t: Array[Tile] = []
	for i in boardSizeX:
		if i != tile.boardX:
			t.append(getTile(i,tile.boardY))
	for i in boardSizeY:
		if i != tile.boardY:
			t.append(getTile(tile.boardX,i))
	return t

func getDiagonalTiles(tile: Tile) -> Array[Tile]:
	var t: Array[Tile] = []
	#Diagonal /
	var offset:int = tile.boardX - tile.boardY
	for i in max(boardSizeX,boardSizeY):
		if i != tile.boardY and i + offset >= 0 and i + offset < boardSizeX and i < boardSizeY:
			t.append(getTile(i + offset , i))
	#Diagonal \
	var offset2:int = tile.boardX + tile.boardY
	for i in max(boardSizeX,boardSizeY):
		if i != tile.boardY and offset2 - i >= 0 and offset2 - i < boardSizeX and i < boardSizeY:
			t.append(getTile(offset2 - i , i))
	return t

func getHorse(tile: Tile) -> Array[Tile]:
	return getKnightMoveTiles(tile)
func getKnightMoveTiles(tile: Tile) -> Array[Tile]:
	var t: Array[Tile] = []
	t.append(getTile(tile.boardX+1,tile.boardY+2))
	t.append(getTile(tile.boardX-1,tile.boardY+2))
	t.append(getTile(tile.boardX+2,tile.boardY+1))
	t.append(getTile(tile.boardX+2,tile.boardY-1))
	t.append(getTile(tile.boardX+1,tile.boardY-2))
	t.append(getTile(tile.boardX-1,tile.boardY-2))
	t.append(getTile(tile.boardX-2,tile.boardY+1))
	t.append(getTile(tile.boardX-2,tile.boardY-1))
	t = t.filter(func(i): return i != null)
	return t

func getTilesInRange (tile: Tile, distance: int) -> Array[Tile]:
	return getAllOtherTiles(tile).filter(func(i: Tile): return abs(i.boardX - tile.boardX) + abs(i.boardY - tile.boardY) <= distance)

##---GET INFORMATION---

func canMovePawn(startingTile: Tile, endingTile: Tile) -> bool:
	return !startingTile.isTileEmpty() and !endingTile.isOccupied()

func getRange(tile1: Tile, tile2: Tile) -> int :
	return abs(tile1.boardX - tile2.boardX) + abs(tile1.boardY - tile2.boardY)

func areAligned(tile1: Tile, tile2: Tile) -> bool:
	return tile1.boardX == tile2.boardX or tile1.boardY == tile2.boardY

func areDiagonal(tile1: Tile, tile2: Tile) -> bool:
	return tile1.boardX - tile1.boardY == tile2.boardX - tile2.boardY or tile1.boardX + tile1.boardY == tile2.boardX + tile2.boardY

func isOnEdge(tile: Tile) -> bool:
	return tile.boardX == 0 or tile.boardY == 0 or tile.boardX == boardSizeX - 1 or tile.boardY == boardSizeY - 1

func isInCorner(tile: Tile) -> bool:
	return [tile.boardX == 0, tile.boardY == 0, tile.boardX == boardSizeX - 1, tile.boardY == boardSizeY - 1].count(true) == 2
