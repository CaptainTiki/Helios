extends Node3D
class_name BlockController

@export var row_height : int = 20
@export var descent_speed : float = 6.0
@export var starting_density : float = 0.1 #10 percent filled
@export var density_increase : float = 0.01
@export var block_spacing : int = 25
@export var field_size : int = 75

@onready var block_container: Node3D = $BlockContainer
@onready var pickup_container: Node3D = $PickupContainer

@onready var block_scene = preload("uid://ceiiwrjj4pjxu")
@onready var pickup_scene = preload("uid://dqp76bq7g7rff")

@onready var label: Label = $Control/Label

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

func _physics_process(delta: float) -> void:
	block_container.position.z += descent_speed * delta
	if block_container.position.z >= -row_height:
		_spawn_row()
		block_container.global_position.z -= row_height
		for block in block_container.get_children():
			if block is BlockBase:
				block.position.z += row_height
	label.text = str(block_container.get_child_count())

func _spawn_row() -> void:
	current_density += density_increase
	
	for i in range(slots.size()):
		if randf() < current_density:
			var newblock : BlockBase = block_scene.instantiate() as BlockBase
			block_container.add_child(newblock)
			newblock.position = slots[i]
			newblock.run_root = run_root
			newblock.died.connect(_on_block_died)

func _on_block_died(location: Vector3, expl_energy : float) -> void:
	var pickup : PickupBase = pickup_scene.instantiate() as PickupBase
	pickup_container.add_child(pickup)
	pickup.setup(expl_energy, location)
	pickup.picked_up.connect(_on_pickup_pickedup)

func _on_pickup_pickedup(value : float) -> void:
	run_root.add_joules(value)
