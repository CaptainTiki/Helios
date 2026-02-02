extends Node3D
class_name RunScene

signal run_ended(joules_earned: int)
signal save_and_quit_requested

@onready var pause_menu: Control = $HUD/PauseMenu
@onready var hud_label: Label = $HUD/TopLeftDock/HudLabel

var ended := false

func _ready() -> void:
	_update_hud()

	# Wire pause menu buttons
	pause_menu.resume_pressed.connect(_on_resume)
	pause_menu.settings_pressed.connect(_on_settings)
	pause_menu.save_quit_pressed.connect(_on_save_quit)

func _process(_delta: float) -> void:
	_update_hud()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()
		get_viewport().set_input_as_handled()
		return

	# Temporary debug: press K to end run + grant some joules
	if event is InputEventKey and event.pressed and event.keycode == KEY_K:
		GameSession.joules_this_run += 50
		GameSession.threat_level = max(GameSession.threat_level, 3)
		end_run()

func _toggle_pause() -> void:
	var new_paused := not get_tree().paused
	get_tree().paused = new_paused
	pause_menu.visible = new_paused

func _on_resume() -> void:
	if get_tree().paused:
		get_tree().paused = false
	pause_menu.visible = false

func _on_settings() -> void:
	# Stub: you can open a settings overlay here later.
	pass

func _on_save_quit() -> void:
	# GDD rule: can't quit without saving → MainScene will handle the modal.
	if get_tree().paused:
		get_tree().paused = false
	emit_signal("save_and_quit_requested")

func end_run() -> void:
	if ended:
		return
	ended = true
	emit_signal("run_ended", GameSession.joules_this_run)

func _update_hud() -> void:
	hud_label.text = "RUN (stub)\nJoules this run: %d\nThreat: %d\n(ESC = Pause, K = End Run)" % [
		GameSession.joules_this_run,
		GameSession.threat_level
	]
