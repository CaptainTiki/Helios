extends Node
class_name RunData

# Run-only data
var joules_this_run: float = 0
var threat_level: int = 0
var hull: float = 5.0

func reset_for_new_run() -> void:
	joules_this_run = 0
	threat_level = 0
	hull = 5.0
