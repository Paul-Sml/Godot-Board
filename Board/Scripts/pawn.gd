extends TextureRect
class_name Pawn

@export var pawnData: PawnResource

func _init(data: PawnResource) -> void:
	pawnData = data

func _ready() -> void:
	z_index = 10
	if pawnData.image:
		self.texture = pawnData.image
