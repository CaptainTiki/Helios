extends Node
class_name Save_Manager

const SAVE_DIR := "user://saves/"
const LATEST_SLOT := "slot_1" # Jam scope: one slot (expand later)

func new_game() -> void:
	GameSession.total_joules = 0
	GameSession.upgrades = {}
	GameSession.has_active_profile = true
	GameSession.active_save_slot = LATEST_SLOT
	save_profile()

func save_profile() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	var path := SAVE_DIR + GameSession.active_save_slot + ".json"

	var data := {
		"total_joules": GameSession.total_joules,
		"upgrades": GameSession.upgrades,
		"active_save_slot": GameSession.active_save_slot,
	}

	var f := FileAccess.open(path, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))
		f.close()

func load_latest() -> bool:
	var path := SAVE_DIR + LATEST_SLOT + ".json"
	if not FileAccess.file_exists(path):
		return false

	var f := FileAccess.open(path, FileAccess.READ)
	if not f:
		return false

	var data = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(data) != TYPE_DICTIONARY:
		return false

	GameSession.total_joules = int(data.get("total_joules", 0))
	GameSession.upgrades = data.get("upgrades", {})
	GameSession.active_save_slot = String(data.get("active_save_slot", LATEST_SLOT))
	GameSession.has_active_profile = true
	return true

# --- GDD autosave rules ---
func autosave_on_run_start() -> void:
	save_profile()

func autosave_on_run_complete(joules_earned: int) -> void:
	GameSession.total_joules += joules_earned
	save_profile()
