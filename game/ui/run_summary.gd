extends Control

signal upgrade_pressed
signal redeploy_pressed
signal save_quit_pressed

func _ready() -> void:
    $Margin/VBox/UpgradeButton.pressed.connect(func(): emit_signal("upgrade_pressed"))
    $Margin/VBox/RedeployButton.pressed.connect(func(): emit_signal("redeploy_pressed"))
    $Margin/VBox/SaveQuitButton.pressed.connect(func(): emit_signal("save_quit_pressed"))

func set_summary(joules_earned: int, threat_reached: int) -> void:
    $Margin/VBox/SummaryLabel.text = "Run Complete\nJoules Earned: %d\nThreat Reached: %d" % [joules_earned, threat_reached]
