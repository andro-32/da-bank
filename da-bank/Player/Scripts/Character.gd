extends CharacterBody2D
class_name Character

@export var SPEED := 750.0
@export var JUMP_VELOCITY := -800.0
@export var ACCELERATION := 0.1

@onready var jump_particles := $Particles/JumpDust
@onready var move_particles := $Particles/Dust
@onready var speed_lines := $Particles/SpeedLines
@onready var sprite := $Sprite2D

var jumping := false
var vel := Vector2.ZERO

func animation_playing(animation: String) -> bool:
	return sprite.animation == name + animation and sprite.is_playing()

func _physics_process(delta: float) -> void:
	velocity.x = lerp(velocity.x,vel.x,ACCELERATION)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if jumping:
		sprite.stop()
		sprite.speed_scale = 1.0
		sprite.play(name + "Jump")
		sprite.animation = name + "Jump"
		velocity.y = JUMP_VELOCITY
		jump_particles.emitting = true

	# particles
	if is_on_floor():
		if abs(velocity.x) >= 75.0: move_particles.emitting = true
		else: move_particles.emitting = false
	else: move_particles.emitting = false

	move_particles.initial_velocity_min = 400.0 * (abs(velocity.x)/SPEED)
	move_particles.initial_velocity_max = 500.0 * (abs(velocity.x)/SPEED)
	move_particles.texture.width = clamp(24 * (abs(velocity.x)/SPEED),1,24)
	move_particles.texture.height = clamp(24 * (abs(velocity.x)/SPEED),1,24)

	if abs(velocity.x) != velocity.x:
		# left
		move_particles.direction.x = -1.0
		move_particles.angular_velocity_min = 500.0
		move_particles.angular_velocity_max = 500.0
	else:
		# right
		move_particles.direction.x = 1.0
		move_particles.angular_velocity_min = -500.0
		move_particles.angular_velocity_max = -500.0

	speed_lines.texture.height = clamp((abs(velocity.x/10)) + (abs(velocity.y)) / 10,1,1.0/0.0)
	speed_lines.direction = -velocity
	if (abs(velocity.x)) + (abs(velocity.y)) >= 75.0: speed_lines.emitting = true
	else: speed_lines.emitting = false

	if is_on_floor() and !jumping:
		if abs(velocity.x) >= 15.0:
			if !animation_playing(name + "Move") and !animation_playing("Jump") and !animation_playing("Fall"): sprite.stop()
			if abs(velocity.x) != velocity.x: sprite.flip_h = true
			else: sprite.flip_h = false
			sprite.speed_scale = abs(velocity.x)/SPEED
			sprite.play(name + "Move")
		else:
			if !animation_playing("Idle") and !animation_playing("Jump") and !animation_playing("Fall"): sprite.stop()
			sprite.speed_scale = 1.0
			sprite.play(name + "Idle",1.0)
	else:
		if !(animation_playing("Jump")) and !jumping:
			sprite.speed_scale = 1.0
			sprite.play(name + "Fall")

	jumping = false
	vel = Vector2.ZERO
	move_and_slide()
