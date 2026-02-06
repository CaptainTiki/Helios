extends Node3D
class_name HealthController

signal died()

@export var debug : bool = false

var run_root : RunRoot = null

func _ready() -> void:
	run_root = $"../../"

func take_damage(dmg : float) -> void:
	if dmg > 0:
		run_root.rundata.hull -= dmg
	
	if run_root.rundata.hull <= 0:
		die()

func get_current_health() -> float:
	return run_root.rundata.hull

func die() -> void:
	if debug:
		print("player Died")
	died.emit()
