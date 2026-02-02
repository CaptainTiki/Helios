extends Control

signal resume_pressed
signal settings_pressed
signal save_quit_pressed

func _ready() -> void:
    visible = false
    $Panel/Margin/VBox/ResumeButton.pressed.connect(func(): emit_signal("resume_pressed"))
    $Panel/Margin/VBox/SettingsButton.pressed.connect(func(): emit_signal("settings_pressed"))
    $Panel/Margin/VBox/SaveQuitButton.pressed.connect(func(): emit_signal("save_quit_pressed"))
