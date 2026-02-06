extends Area3D
class_name PickupBase

signal picked_up(value : float)

var fall_speed : float = 18
var accel : float = 0.1
var velocity : Vector3 = Vector3.ZERO
var max_value : float = 5.0
var min_value : float = 1.0
var value : float = 0.0

func setup(explosive_energy: float, position : Vector3) -> void:
	var x : float = randf_range(-1, 1)
	var z : float = randf_range(-1, 0) #because we only want to blow upwards
	velocity = Vector3(x, 0, z) * explosive_energy
	value = randf_range(min_value, max_value)
	global_position = position

func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(Vector3(0, 0, fall_speed), accel)
	global_position += velocity * delta


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		picked_up.emit(value)
		queue_free()
