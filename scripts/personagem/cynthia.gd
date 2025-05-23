extends CharacterBody2D

var speed = 300
var jump_force = -600
var gravity = 1500

var following_orbs := []
var float_time := 0.0

@onready var sprite = $AnimatedSprite2D
@onready var orb_follow_point = $OrbFollowPoint

func _physics_process(delta):
	global_position.x = clamp(global_position.x, 50, 3000) # Mudar o limite da direita depois
	global_position.y = clamp(global_position.y, 50, 670)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
	
	move_and_slide()

	if not is_on_floor():
		sprite.play("jump")
	elif abs(velocity.x) > 0.1:
		sprite.play("run")
	else:
		sprite.play("idle")
	
	if direction != 0:
		sprite.flip_h = direction < 0

	update_following_orbs(delta)

func add_following_orb(orb):
	if not following_orbs.has(orb):
		following_orbs.append(orb)
		call_deferred("_reparent_orb", orb)
		orb.z_index = z_index - 1
		orb.z_as_relative = false
		var horizontal_offset = randf_range(-30, 30)
		orb.position = orb_follow_point.position + Vector2(horizontal_offset, 0)

func _reparent_orb(orb):
	if orb.get_parent():
		orb.get_parent().remove_child(orb)
	add_child(orb)

func update_following_orbs(delta):
	float_time += delta * 3
	var back_distance = 250
	var vertical_base_offset = 0 
	var spacing = 25

	for i in range(following_orbs.size()):
		var orb = following_orbs[i]
		if is_instance_valid(orb):
			var spread = spacing * (i - (following_orbs.size() - 1) / 2.0)
			var vertical_float = sin(float_time + i) * 5
			var side = 1 if not sprite.flip_h else -1

			var target_pos = orb_follow_point.position + Vector2(side * back_distance + spread, vertical_base_offset + vertical_float)
			orb.position = orb.position.lerp(target_pos, 10 * delta)
			orb.scale.x = 1 if sprite.flip_h else -1
