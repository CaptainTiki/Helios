extends Node3D
class_name BlockController

@export var row_height : int = 20
@export var descent_speed : float = 6.0
@export var starting_density : float = 1.0 #10 percent filled
@export var density_increase : float = 0.01
@export var block_spacing : int = 25
@export var field_size : int = 75

@onready var block_container: Node3D = $BlockContainer
@onready var block_scene = preload("uid://ceiiwrjj4pjxu")

var height_counter : float = 0
var current_density : float = 0

var run_root : RunRoot = null

var slots : Array[Vector3] = [
	Vector3(-75,0,-80),
	Vector3(-50,0,-80),
	Vector3(-25,0,-80),
	Vector3(  0,0,-80),
	Vector3( 25,0,-80),
	Vector3( 50,0,-80),
	Vector3( 75,0,-80)
	]


func _ready() -> void:
	run_root = $"../../"
	current_density = starting_density
	_spawn_row()

func _physics_process(delta: float) -> void:
	block_container.position.z += descent_speed * delta
	if block_container.position.z >= -row_height:
		_spawn_row()
		block_container.global_position.z -= row_height
		for block in block_container.get_children():
			if block is BlockBase:
				block.position.z += row_height

func _spawn_row() -> void:
	current_density += density_increase
	
	for i in range(slots.size()):
		if randf() < current_density:
			var newblock : BlockBase = block_scene.instantiate() as BlockBase
			block_container.add_child(newblock)
			newblock.position = slots[i]
			newblock.run_root = run_root
