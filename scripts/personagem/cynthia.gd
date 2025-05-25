extends CharacterBody2D

var speed = 300
var jump_force = -600
var gravity = 1500

var following_orbs := []
var float_time := 0.0

@onready var sprite = $AnimatedSprite2D
@onready var orb_follow_point = $OrbFollowPoint
@onready var steps_sound = null


func _ready():
	if not has_node("OrbContainer"):
		var container = Node2D.new()
		container.name = "OrbContainer"
		add_child(container)

	if get_parent().has_node("steps"):
		steps_sound = get_parent().get_node("steps")
	else:
		steps_sound = null


func _physics_process(delta):
	global_position.x = clamp(global_position.x, 50, 100000)
	global_position.y = clamp(global_position.y, 50, 670)

	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()

	# Animações
	if not is_on_floor():
		sprite.play("jump")
	elif abs(velocity.x) > 0.1:
		sprite.play("run")
	else:
		sprite.play("idle")

	if direction != 0:
		sprite.flip_h = direction < 0

	var is_running = is_on_floor() and abs(velocity.x) > 0.1
	if steps_sound:
		if is_running and not steps_sound.playing:
			steps_sound.play()
		elif not is_running and steps_sound.playing:
			steps_sound.stop()

	update_following_orbs(delta)


func add_following_orb(orb):
	if not following_orbs.has(orb) and is_instance_valid(orb):
		following_orbs.append(orb)

		if is_instance_valid(orb.get_parent()):
			orb.get_parent().remove_child(orb)

		$OrbContainer.add_child(orb)

		orb.position = Vector2.ZERO
		orb.global_position = orb_follow_point.global_position
		orb.scale = Vector2.ONE


func update_following_orbs(delta):
	float_time += delta * 3
	var back_distance = 250
	var spacing = 25

	for i in range(following_orbs.size()):
		var orb = following_orbs[i]
		if is_instance_valid(orb):
			var spread = spacing * (i - (following_orbs.size() - 1) / 2.0)
			var vertical_float = sin(float_time + i) * 5
			var side = 1 if not sprite.flip_h else - 1

			var target_pos = orb_follow_point.position + Vector2(
				side * (back_distance + spread),
				vertical_float
			)
			orb.position = orb.position.lerp(target_pos, 10 * delta)
			orb.scale.x = 1 if sprite.flip_h else - 1
