extends StaticBody3D
class_name BlockBase

signal spawned
signal died(location: Vector3, expl_energy : float)

@export var debug : bool = false
@export_category("Vars")
@export var max_health : float = 3
@export var damage: float = 1
@export var score_value: float = 1
@export var explosion_energy : float = 108.3

var run_root : RunRoot = null
var health : float = 1.0
var dangerous : bool = false #a block becomes dangerous when its over the danger line

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawned.emit()
	health = max_health

func _process(_delta: float) -> void:
	if not dangerous : #not below the danger line, we're normal
		return
	#down here - we need to blink.. or wiggle or something

func heal(hp : float) -> void:
	if hp <= 0:
		return
	
	health += hp

func take_damage(dmg : float) -> void:
	if dmg <= 0:
		return
	
	health -= dmg
	if health <= 0:
		run_root.add_score(score_value)
		die()

func attack_player() -> void:
	run_root.damage_player(damage)
	die()

func die() -> void:
	died.emit(global_position, explosion_energy)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		attack_player()
