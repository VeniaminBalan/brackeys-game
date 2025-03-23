extends CharacterBody2D
class_name Player

signal collected()

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var freeze = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var die_timer: Timer = $DieTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var camera_2d: Camera2D = $Camera2D

var game_manager : GameManager

func _physics_process(delta: float) -> void:
	if freeze:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif  direction < 0:
		animated_sprite.flip_h = true
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func teleport_to(target: Vector2, delay = 1):
	hide()
	position = target
	freeze = true
	velocity = Vector2(0,0)
	timer.start(delay)

	

func _on_timer_timeout() -> void:
	freeze = false
	show()
	
func collect():
	collected.emit()

func die():
	await get_tree().process_frame
	collision_shape_2d.disabled = true
	Engine.time_scale = 0.5
	die_timer.start(0.6)
	
func _on_die():
	pass

func _on_die_timer_timeout() -> void:
	Engine.time_scale = 1
	await get_tree().process_frame
	teleport_to(game_manager.world.start_position, 0.6)
	collision_shape_2d.disabled = false
