extends Control

signal redeploy_pressed
signal back_to_menu_pressed

func _ready() -> void:
    $Margin/VBox/RedeployButton.pressed.connect(func(): emit_signal("redeploy_pressed"))
    $Margin/VBox/BackButton.pressed.connect(func(): emit_signal("back_to_menu_pressed"))

func _process(_delta: float) -> void:
    $Margin/VBox/MetaLabel.text = "Total Joules: %d" % GameSession.total_joules
