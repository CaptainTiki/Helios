extends Node
class_name MainScene

@onready var screen_host: Control = $ScreenRoot/ScreenHost
@onready var game_root: Node = $GameRoot

var current_screen: Node = null
var current_game: Node = null

# Tracks why we opened the save+quit modal
var _pending_quit_mode: String = "" # "desktop" | "menu"


func _ready() -> void:
	show_title()


# ---------- Helpers ----------
func _set_screen(packed: PackedScene) -> void:
	if current_screen:
		current_screen.queue_free()
		current_screen = null

	current_screen = packed.instantiate()
	screen_host.add_child(current_screen)
	_wire_screen(current_screen)


func _clear_game() -> void:
	if current_game:
		current_game.queue_free()
		current_game = null


func _set_game(packed: PackedScene) -> void:
	_clear_game()
	current_game = packed.instantiate()
	game_root.add_child(current_game)
	_wire_game(current_game)


# ---------- Flow ----------
func show_title() -> void:
	_clear_game()
	_set_screen(preload("res://menus/title_screen.tscn"))


func show_main_menu() -> void:
	_clear_game()
	_set_screen(preload("res://menus/main_menu.tscn"))


func show_load_menu() -> void:
	_set_screen(preload("res://menus/load_menu.tscn"))


func show_settings_menu() -> void:
	_set_screen(preload("res://menus/settings_menu.tscn"))


func show_upgrade_bay() -> void:
	_clear_game()
	_set_screen(preload("res://game/ui/upgrade_bay.tscn"))


func start_run() -> void:
	# Hide menu UI during the run; HUD is inside RunScene.
	if current_screen:
		current_screen.queue_free()
		current_screen = null

	GameSession.reset_for_new_run()
	SaveManager.autosave_on_run_start()
	_set_game(preload("res://game/level/run_root.tscn"))


func show_run_summary(joules_earned: int) -> void:
	SaveManager.autosave_on_run_complete(joules_earned)
	_clear_game()
	_set_screen(preload("res://game/ui/run_summary.tscn"))


# ---------- Wiring ----------
func _wire_screen(screen: Node) -> void:
	# Title
	if screen.has_signal("start_pressed"):
		screen.connect("start_pressed", show_main_menu)

	# Main Menu
	if screen.has_signal("new_game_pressed"):
		screen.connect("new_game_pressed", _on_new_game)
	if screen.has_signal("continue_pressed"):
		screen.connect("continue_pressed", _on_continue)
	if screen.has_signal("load_pressed"):
		screen.connect("load_pressed", show_load_menu)
	if screen.has_signal("settings_pressed"):
		screen.connect("settings_pressed", show_settings_menu)
	if screen.has_signal("quit_pressed"):
		screen.connect("quit_pressed", _on_quit_from_menu)

	# Load Menu
	if screen.has_signal("load_slot_pressed"):
		screen.connect("load_slot_pressed", _on_load_slot)
	if screen.has_signal("back_pressed"):
		screen.connect("back_pressed", show_main_menu)

	# Settings Menu
	if screen.has_signal("back_pressed"):
		screen.connect("back_pressed", show_main_menu)

	# Upgrade Bay
	if screen.has_signal("redeploy_pressed"):
		screen.connect("redeploy_pressed", start_run)
	if screen.has_signal("back_to_menu_pressed"):
		screen.connect("back_to_menu_pressed", _on_save_and_quit_to_menu)

	# Run Summary
	if screen.has_signal("upgrade_pressed"):
		screen.connect("upgrade_pressed", show_upgrade_bay)
	if screen.has_signal("redeploy_pressed"):
		screen.connect("redeploy_pressed", start_run)
	if screen.has_signal("save_quit_pressed"):
		screen.connect("save_quit_pressed", _on_save_and_quit_to_menu)

	# Save & Quit Modal
	if screen.has_signal("confirm_pressed"):
		screen.connect("confirm_pressed", _on_modal_confirm)
	if screen.has_signal("cancel_pressed"):
		screen.connect("cancel_pressed", _on_modal_cancel)


func _wire_game(game: Node) -> void:
	if game.has_signal("run_ended"):
		game.connect("run_ended", show_run_summary)
	if game.has_signal("save_and_quit_requested"):
		game.connect("save_and_quit_requested", _on_save_and_quit_to_menu)


# ---------- Actions ----------
func _on_new_game() -> void:
	SaveManager.new_game()
	show_upgrade_bay()


func _on_continue() -> void:
	if SaveManager.load_latest():
		show_upgrade_bay()
	else:
		SaveManager.new_game()
		show_upgrade_bay()


func _on_load_slot(_slot_id: String) -> void:
	# Jam scope: only slot_1 exists, so we just load_latest.
	if SaveManager.load_latest():
		show_upgrade_bay()
	else:
		SaveManager.new_game()
		show_upgrade_bay()


func _on_quit_from_menu() -> void:
	# GDD rule: can't quit without saving if a profile exists.
	if GameSession.has_active_profile:
		_pending_quit_mode = "desktop"
		_set_screen(preload("res://menus/save_and_quit_modal.tscn"))
	else:
		get_tree().quit()


func _on_save_and_quit_to_menu() -> void:
	_pending_quit_mode = "menu"
	_set_screen(preload("res://menus/save_and_quit_modal.tscn"))


func _on_modal_confirm() -> void:
	SaveManager.save_profile()
	GameSession.has_active_profile = false
	_clear_game()

	if _pending_quit_mode == "desktop":
		get_tree().quit()
	else:
		show_main_menu()


func _on_modal_cancel() -> void:
	# If they cancel, try to return them somewhere sensible.
	# (This is intentionally simple — we can refine navigation later.)
	if current_game:
		# If we're in a run, let the run keep control (pause menu etc).
		if current_screen:
			current_screen.queue_free()
			current_screen = null
	else:
		show_main_menu()
