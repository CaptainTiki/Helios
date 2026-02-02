extends Control

signal load_slot_pressed(slot_id: String)
signal back_pressed

func _ready() -> void:
    $Margin/VBox/Slot1Button.pressed.connect(func(): emit_signal("load_slot_pressed", "slot_1"))
    $Margin/VBox/BackButton.pressed.connect(func(): emit_signal("back_pressed"))
