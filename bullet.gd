extends Node3D

signal hit

var speed := 40.0

@onready var mesh = $RigidBody3D/MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -speed) * delta
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		if ray.get_collider().is_in_group("Target"):
			#print("hit")
			ray.get_collider().process_mode = 4
			ray.get_collider().hide()
			#$main/cube/GPUParticles3D.emitting = true
			
			hit.emit()
			pass
		await get_tree().create_timer(1.0).timeout
		#print(ray.get_collider())

		queue_free()


func _on_timer_timeout() -> void:
	queue_free()


func _on_rigid_body_3d_body_entered(_body: Node) -> void:
	pass


func _on_rigid_body_3d_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("Target"):
		print("hit target")
	print("hit")
