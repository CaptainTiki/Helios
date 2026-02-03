extends Area3D
class_name KillZone


func _on_body_entered(body: Node3D) -> void:
	if body is BlockBase:
		body.attack_player()
