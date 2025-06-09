extends CharacterBody2D

var speed = 300
var jump_force = -600
var gravity = 1500

var following_orbs := []
var float_time : float = 0.0

@onready var sprite = $AnimatedSprite2D
@onready var orb_follow_point = $OrbFollowPoint
@onready var steps_sound = null

func _ready():
	if not has_node("OrbContainer"):
		var container = Node2D.new()
		container.name = "OrbContainer"
		add_child(container)

	if get_parent() and get_parent().has_node("steps"):
		steps_sound = get_parent().get_node("steps")

func set_player_control(enable: bool):
	set_physics_process(enable)
	if not enable:
		velocity = Vector2.ZERO
		if is_on_floor():
			sprite.play("idle")

func _physics_process(delta):
	global_position.x = clamp(global_position.x, 50, 5970)
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
		orb.global_position = orb_follow_point.global_position
		orb.scale = Vector2.ONE

func update_following_orbs(delta_param):
	if typeof(delta_param) != TYPE_FLOAT:
		# Fallback caso delta_param chegue com tipo inesperado
		# Idealmente, isso não deveria acontecer se a causa raiz foi corrigida
		if get_tree() != null and get_tree().get_root() != null : #Evita erro ao sair do jogo
			delta_param = get_physics_process_delta_time() 
			if typeof(delta_param) != TYPE_FLOAT: # Último recurso
				delta_param = 1.0 / Engine.get_physics_ticks_per_second() if Engine.get_physics_ticks_per_second() > 0 else 1.0/60.0
		else: # Se não consegue pegar o delta do motor, usa um valor padrão
			delta_param = 1.0/60.0


	float_time += delta_param * 3

	var back_distance = 250
	var spacing = 25

	for i in range(following_orbs.size()):
		var orb = following_orbs[i]
		if is_instance_valid(orb):
			var spread = spacing * (i - (following_orbs.size() - 1) / 2.0)
			var vertical_float = sin(float_time + i * 0.5) * 10 
			var side = 1.0 if not sprite.flip_h else -1.0

			var target_pos_offset = Vector2(
				side * (back_distance + spread),
				vertical_float
			)
			var target_global_pos = orb_follow_point.global_position + target_pos_offset
			orb.global_position = orb.global_position.lerp(target_global_pos, 10 * delta_param)
			if side != orb.scale.x:
				orb.scale.x = side
				
func unite_following_orbs(target_position: Vector2):
	if following_orbs.is_empty():
		return

	var duration = 1.5
	for orb in following_orbs:
		var tween = create_tween()
		tween.tween_property(orb, "global_position", target_position, duration).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(orb, "modulate:a", 0.0, 0.2).set_delay(duration - 0.2)
