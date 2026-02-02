extends Control

signal start_pressed

func _ready() -> void:
    $Margin/VBox/StartButton.pressed.connect(func(): emit_signal("start_pressed"))
