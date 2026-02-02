extends Node
class_name Game_Session

# Persistent meta-progression
var total_joules: int = 0
var upgrades: Dictionary = {} # e.g. {"offense.damage": 2, "systems.magnet": 1}

# Run-only data
var joules_this_run: int = 0
var threat_level: int = 0
var hull: float = 100.0

var has_active_profile: bool = false
var active_save_slot: String = "slot_1"

func reset_for_new_run() -> void:
	joules_this_run = 0
	threat_level = 0
	hull = 100.0
