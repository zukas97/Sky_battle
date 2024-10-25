extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func on_hit() -> void:
	get_child(2).emitting = true
	


func _on_body_entered(body: Node) -> void:
	if body.name == "RigidBody3D":
		print("hit")
