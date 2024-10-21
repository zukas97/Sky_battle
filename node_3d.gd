extends Node3D

@onready var crosshair = $crosshair
#@onready var crosshair+hit 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	crosshair.position.x = get_viewport().size.x / 2 - 7.5
	crosshair.position.y = get_viewport().size.y / 2 - 7.5
