extends Character
class_name Player

@onready var camera := $Camera2D


func _physics_process(delta: float) -> void:

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")

	velocity.x = lerp(velocity.x,direction * SPEED,ACCELERATION)

	camera.position = lerp(camera.position,position,0.1)
	super(delta)
