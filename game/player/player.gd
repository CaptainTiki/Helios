extends CharacterBody3D
class_name Player

@export var debug : bool = false
@export_category("Movement")
@export var max_speed : float = 96
@export var accel : float = 8
@export var decel : float = 18
@export_category("Ball Vars")
@export var serve_influence = 0.75
@export var return_influence = 0.45
@export_category("references")
@export var bullet_root : Node3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var debug_label: Label = $Control/VBoxContainer/Debug_Label
@onready var debug_label_2: Label = $Control/VBoxContainer/Debug_Label2

@onready var ball_scene = preload("uid://cvhmjswxrcomw")
@onready var rig: Node3D = $Rig

var staged_ball : BallBase = null

var target
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_stage_ball()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	debug_label.text = str(global_position)
	debug_label_2.text = str(velocity)
	_move_paddle(delta)
	if Input.is_action_just_pressed("launch_ball"):
		_launch_ball()
	if Input.is_action_just_pressed("fire_weapon"):
		_stage_ball()
	
	move_and_slide()
	global_position.x = clamp(global_position.x, -83, 83)

func _move_paddle(delta: float) -> void:
	var move_horizontal : float = 0.0
	var move_delta : float = 0.0
	move_horizontal = Input.get_axis("move_left", "move_right")
	
	if velocity.x > 0: #moving right
		if move_horizontal > 0:
			move_delta = accel
		else:
			move_delta = decel
	elif velocity.x < 0: #moving left
		if move_horizontal < 0:
			move_delta = accel
		else:
			move_delta = decel
	else: #we're not moving yet - use accel
		move_delta = accel
	
	velocity.x = lerp(velocity.x, move_horizontal * max_speed, move_delta * delta)

func _stage_ball() -> void:
	if staged_ball:
		return
	
	staged_ball= ball_scene.instantiate() as BallBase
	rig.add_child(staged_ball)
	staged_ball.global_position = global_position + Vector3(0,0,-1.5)


func _launch_ball() -> void:
	if staged_ball:
		var english = clamp( velocity.x / max_speed, -1, 1 )
		var x_dir = english * serve_influence
		var dir = Vector3(x_dir,0,-1).normalized()
		staged_ball.launch(dir, bullet_root)
		staged_ball = null
