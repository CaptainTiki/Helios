extends Node3D
class_name ScoringController

@onready var score_value_label: Label = %Score_Value_Label

var total_score : float = 0.0
var total_joules : float = 0.0
var run_root : RunRoot = null

func _ready() -> void:
	run_root = $"../../"

func add_score(amt : float) -> void:
	if amt <= 0:
		return
	
	total_score += amt

func add_joules(amt : float) -> void:
	if amt <= 0:
		return
	
	total_joules += amt
	run_root.rundata.joules_this_run = total_joules
