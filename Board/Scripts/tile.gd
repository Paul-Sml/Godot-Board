extends Control
class_name Tile

#Board position
var boardX: int
var boardY: int
var boardXY: Vector2i

@onready var board: Board = self.get_parent()

@onready var on_tile: CenterContainer = $OnTile

var holding: bool = false

@onready var display: Control = $Display
var baseColor: Color = Color.TRANSPARENT
var currentColor: Color
@onready var colorDisplay: ColorRect = $Display/Color
@onready var textureDisplay: TextureRect = $Display/Texture

func _ready() -> void:
	pass


##---INTERACTIONS---

#Hovering
func _on_display_mouse_entered() -> void:
	board.hoveredTile = self
	setColor(currentColor*1.15)
func _on_display_mouse_exited() -> void:
	board.hoveredTile = null
	setColor(currentColor)

##---ACTIONS---

func placeNodeOnTile(node: Node) -> void:
	on_tile.add_child(node)

func removeNodeOnTile(node: Node) -> void:
	on_tile.remove_child(node)

##---GAME INFORMATION---

#Check if something is on the tile
func isTileEmpty() -> bool:
	return on_tile.get_child_count() == 0
	
#Check if something occupies the tile
func isOccupied() -> bool:
	for i in getAllNodesOnTile():
		if i is Pawn:
			if i.occupiesTile:
				return true
	return false

#Returns the first child of the tile. Use when certain there is only 1 child (or always need first child)
func getPawnOnTile() -> Pawn:
	return on_tile.get_child(0) if on_tile.get_child(0) is Pawn else null

#Returns the child of specified index
func getSpecificNodeOnTile(index: int) -> Node:
	return on_tile.get_child(index)

#Returns everything on the tile as an Array
func getAllNodesOnTile() -> Array[Node]:
	return on_tile.get_children()

#Check if Node in entry is on this tile
func isNodeOnTile(object: Node) -> bool:
	for node in on_tile.get_children():
		if node == object:
			return true
	return false

#Returns a child of the same type as provided, might need to create a new var to get a specific type
func getNodeOfSameTypeOnTile(typedVar):
	for child in on_tile.get_children():
		if child.typeof() == typedVar.typeof():
			return child
	return null

##---INIT---

func setBoardPosition(x: int, y: int) -> void:
	boardX = x
	boardY = y
	boardXY = Vector2i(x,y)

##---EDIT DISPLAY---

#Set a new Texture for the tile
func setTexture(texture: Texture) -> void:
	if textureDisplay:
		textureDisplay.texture = texture

#Set a new Color for the tile. Absolute change, used for hovering.
func setColor(color: Color) -> void:
	if colorDisplay:
		colorDisplay.color = color

#Set a new Current Color for the tile. Used for setting a new permanent Color for UI or other usage.
func setCurrentColor(color: Color) -> void:
	if colorDisplay:
		colorDisplay.color = color
		currentColor = color

#Set a new Base Color for the tile. Used on generation
func setBaseColor(color: Color) -> void:
	if colorDisplay:
		baseColor = color
		colorDisplay.color = color
		currentColor = color

func resetColor() -> void:
	if colorDisplay:
		colorDisplay.color = baseColor
		currentColor = baseColor

#Set a TRANSPARENT as a new Color for the tile. Tile remains fonctional but is transparent (given there is not Texture/Texture is not visible)
func setColorTransparent(color: Color) -> void:
	if colorDisplay:
		colorDisplay.color = Color.TRANSPARENT

#Set the size of the ColorRect
func setColorRectSize(newSize: Vector2) -> void:
	if colorDisplay:
		colorDisplay.size = newSize
	on_tile.size = newSize

func setDisplay(isVisible: bool) -> void:
	display.visible = isVisible

func setTextureDisplay(isVisible: bool) -> void:
	textureDisplay.visible = isVisible

func setColorDisplay(isVisible: bool) -> void:
	colorDisplay.visible = isVisible

##---INFORMATION ABOUT DISPLAY---

#Return the highest Width and Height between the ColorRect and the Texture. Skips non Visible elements
func getTileSize() -> Vector2:
	var actualSize: Vector2 = Vector2(0,0)
	if textureDisplay.texture != null:
		if textureDisplay.visible:
			actualSize = textureDisplay.texture.get_size()
	if colorDisplay.visible:
		actualSize = Vector2(max(actualSize.x, colorDisplay.size.x), max(actualSize.y, colorDisplay.size.y))
	return actualSize
