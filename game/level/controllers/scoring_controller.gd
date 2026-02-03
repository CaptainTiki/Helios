extends Node3D
class_name ScoringController

@onready var score_value_label: Label = %Score_Value_Label

var total_score : float = 0.0

func add_score(amt : float) -> void:
	if amt <= 0:
		return
	
	total_score += amt
