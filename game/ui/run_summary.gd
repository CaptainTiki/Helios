extends Control
class_name RunSummaryScreen

signal upgrade_pressed
signal redeploy_pressed
signal save_quit_pressed

func _ready() -> void:
	$Margin/VBox/UpgradeButton.pressed.connect(func(): emit_signal("upgrade_pressed"))
	$Margin/VBox/RedeployButton.pressed.connect(func(): emit_signal("redeploy_pressed"))
	$Margin/VBox/SaveQuitButton.pressed.connect(func(): emit_signal("save_quit_pressed"))

func set_summary(rundata : RunData) -> void:
	var joules_earned: float = rundata.joules_this_run
	var threat_reached: float = rundata.threat_level
	$Margin/VBox/SummaryLabel.text = "Run Complete\nJoules Earned: %d\nThreat Reached: %d" % [joules_earned, threat_reached]
