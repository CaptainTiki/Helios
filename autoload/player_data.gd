extends Node
class_name Player_Data

# Persistent meta-progression
var total_joules: int = 0
var upgrades: Dictionary = {} # e.g. {"offense.damage": 2, "systems.magnet": 1}

var has_active_profile: bool = false
var active_save_slot: String = "slot_1"
