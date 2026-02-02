extends Control

signal confirm_pressed
signal cancel_pressed

func _ready() -> void:
	$Panel/Margin/VBox/ConfirmButton.pressed.connect(func(): emit_signal("confirm_pressed"))
	$Panel/Margin/VBox/CancelButton.pressed.connect(func(): emit_signal("cancel_pressed"))
