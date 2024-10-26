extends StaticBody3D

@onready var particles = $GPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func on_hit() -> void:
	particles.emitting = true
	$MeshInstance3D.hide()
	await get_tree().create_timer(2.0).timeout
	queue_free()
	
	


func _on_body_entered(body: Node) -> void:
	if body.name == "RigidBody3D":
		print("hit")
