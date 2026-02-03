extends RigidBody3D
class_name BlockBase

@export var debug : bool = false
@export_category("Vars")
@export var max_health : float = 1

var health : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

func heal(hp : float) -> void:
	if hp <= 0:
		return
	
	health += hp

func take_damage(dmg : float) -> void:
	if dmg <= 0:
		return
	
	health -= dmg
	if health <= 0:
		died()

func died() -> void:
	queue_free()
