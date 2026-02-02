extends Control

signal back_pressed

func _ready() -> void:
    $Margin/VBox/BackButton.pressed.connect(func(): emit_signal("back_pressed"))

    # Stub: sliders do nothing (yet). The UI is here so you can wire it later.
