extends Control

signal new_game_pressed
signal continue_pressed
signal load_pressed
signal settings_pressed
signal quit_pressed

func _ready() -> void:
	$Margin/VBox/NewGameButton.pressed.connect(func(): emit_signal("new_game_pressed"))
	$Margin/VBox/ContinueButton.pressed.connect(func(): emit_signal("continue_pressed"))
	$Margin/VBox/LoadButton.pressed.connect(func(): emit_signal("load_pressed"))
	$Margin/VBox/SettingsButton.pressed.connect(func(): emit_signal("settings_pressed"))
	$Margin/VBox/QuitButton.pressed.connect(func(): emit_signal("quit_pressed"))

	# Disable Continue if no save exists (simple polish)
	var path : String = SaveManager.SAVE_DIR + SaveManager.LATEST_SLOT + ".json"
	$Margin/VBox/ContinueButton.disabled = not FileAccess.file_exists(path)
