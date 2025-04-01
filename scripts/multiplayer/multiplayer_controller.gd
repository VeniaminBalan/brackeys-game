extends CharacterBody2D

class_name MultiplayerPlayer

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

@export var player_name := "":
	set(name):
		%PlayerName.text = name
	get():
		return %PlayerName.text
		
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer = $Timer
#@onready var player_ui: CanvasLayer = $PlayerUI
@export var multiplayer_manager: MultiplayerManager

var direction := 0
var do_jump := false
var _is_on_floor := true
var freeze = false

func _ready() -> void:
	_attach_camera()
	if multiplayer.get_unique_id() == player_id:
		%PlayerName.hide()

func _attach_camera():
	# enables camera on the current client
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
		$Camera2D.process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
	else:
		$Camera2D.enabled = false

func _apply_animation(delta: float):
	if _is_on_floor:
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
	

func _apply_movement_from_input(delta: float):
	# this code runs only on the server
	if freeze:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		do_jump = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_is_on_floor = is_on_floor()
		direction = %InputSynchronizer.input_direction
		_apply_movement_from_input(delta)
		
	if not multiplayer.is_server() || multiplayer_manager.host_mode_enabled:
		_apply_animation(delta)
	

func die():
	print(str(player_id) + " died")

# move this logic to the server
func _on_timer_timeout() -> void:
	freeze = false
	show()

func teleport_to(target: Vector2, delay = 1):
	hide()
	position = target
	freeze = true
	velocity = Vector2(0,0)
	timer.start(delay)
