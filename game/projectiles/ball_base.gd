extends CharacterBody3D
class_name BallBase

@export var debug : bool = false
@export_category("Movement")
@export var speed : float = 96
@export_category("Damage")
@export var damage : float = 1.0
@export_category("LifeCycle")
@export var max_stability : int = 5
@export var stability_restore : int = 3
@export var collision_exception : float = 0.05

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var stability = 0
var launch_timer = 0.1
var collision_exception_body : Node3D = null

func _physics_process(_delta: float) -> void:
	var old_velocity = velocity
	move_and_slide()
	bounce(old_velocity)
	
	if stability < 0:
		destroy()


func bounce(old_velocity : Vector3) -> void:
	var collision_count = get_slide_collision_count()
	if collision_count <= 0:
		return #no need to process if no collisions this frame
	for i in range(collision_count):
		var collision : KinematicCollision3D = get_slide_collision(i)
		var node = collision.get_collider() as Node3D
		var bounced : bool = false
		if not node: continue #if the node is null, skip this loop
		if node and node.is_in_group("collidable"):
			var bounce_dir = old_velocity.bounce(collision.get_normal())
			bounce_dir.y = 0
			#var remainder : Vector3 = collision.get_remainder()
			#global_position += remainder.length() * bounce_dir
			velocity = bounce_dir.normalized() * speed
			bounced = true
		if node and node.is_in_group("block"):
			#now that we've bounced - check if we need to damage
			if node.has_method("take_damage"):
				node.take_damage(damage)
		if node and node.is_in_group("player"):
			stability += stability_restore
		if bounced:
			stability -= 1
			return #don't do more bounces this frame
	#if we get here - we never bounced - but we hit something. reset the velocity
	velocity = velocity.normalized() * speed

func stage(paddle : Player) -> void:
	collision_shape_3d.disabled = true
	stability = max_stability
	collision_exception_body = paddle
	add_collision_exception_with(collision_exception_body)

func launch(_dir : Vector3, _root: Node3D) -> void:
	collision_shape_3d.disabled = false
	stability = max_stability
	get_tree().create_timer(collision_exception).timeout.connect(_remove_collision_exception)
	var dir = _dir.normalized() #make sure this is a direction - not a velocity
	velocity = dir * speed #no accel - we just GO with the ball launch
	reparent(_root)

func _remove_collision_exception() -> void:
	remove_collision_exception_with(collision_exception_body)

func destroy() -> void:
	queue_free()
	#TODO: add the ball back to the magazine?
