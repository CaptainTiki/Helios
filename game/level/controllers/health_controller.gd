extends Node3D
class_name HealthController

signal died()

@export var debug : bool = false

var max_health : float = 5
var current_health : float = 0

func _ready() -> void:
	#TODO: get max_health from our "player stats"
	current_health = max_health

func take_damage(dmg : float) -> void:
	if dmg > 0:
		current_health -= dmg
	
	if current_health <= 0:
		die()

func die() -> void:
	if debug:
		print("player Died")
	died.emit()
