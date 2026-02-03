extends StaticBody3D
class_name BlockBase

@export var debug : bool = false
@export_category("Vars")
@export var max_health : float = 3
@export var damage: float = 1
@export var score_value: float = 1

var run_root : RunRoot = null
var health : float = 1.0
var primed : bool = false #a block becomes primed when its over the danger line

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:
	if not primed:
		return

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
		died()

func attack_player() -> void:
	run_root.damage_player(damage)
	died()

func died() -> void:
	queue_free()
