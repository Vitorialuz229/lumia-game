extends CharacterBody2D

var speed = 300
var jump_force = -600
var gravity = 1500
var can_update_following_orbs = true

var pause_menu_scene = preload("res://scenes/ui/PauseMenu.tscn")
var pause_menu_instance = null
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


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused

		if get_tree().paused:
			if not is_instance_valid(pause_menu_instance):
				var ui_layer = get_tree().current_scene.find_child("UI_Layer")
				if ui_layer:
					pause_menu_instance = pause_menu_scene.instantiate()
					ui_layer.add_child(pause_menu_instance) # Adiciona à camada de UI
				else:
					printerr("Nó 'UI_Layer' não encontrado na cena atual!")
		else:
			if is_instance_valid(pause_menu_instance):
				pause_menu_instance.queue_free()
				pause_menu_instance = null

func set_player_control(enable: bool):
	set_physics_process(enable)
	if not enable:
		velocity = Vector2.ZERO
		if is_on_floor():
			sprite.play("idle")

func _physics_process(delta):
	global_position.x = clamp(global_position.x, 50, 4970)
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
	if can_update_following_orbs:
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
		if get_tree() != null and get_tree().get_root() != null : #Evita erro ao sair do jogo
			delta_param = get_physics_process_delta_time() 
			if typeof(delta_param) != TYPE_FLOAT:
				delta_param = 1.0 / Engine.get_physics_ticks_per_second() if Engine.get_physics_ticks_per_second() > 0 else 1.0/60.0
		else:
			delta_param = 1.0/60.0


	float_time += delta_param * 3

	var back_distance = -200
	var spacing = 25

	for i in range(following_orbs.size()):
		var orb = following_orbs[i]
		if is_instance_valid(orb):
			var spread = spacing * (i - (following_orbs.size() - 1) / 2.0)
			var vertical_float = sin(float_time + i * 0.5) * 10 
			var side = -1.0 if not sprite.flip_h else 1.0

			var target_pos_offset = Vector2(
				side * (back_distance + spread),
				vertical_float
			)
			var target_global_pos = orb_follow_point.global_position + target_pos_offset
			orb.global_position = orb.global_position.lerp(target_global_pos, 10 * delta_param)
			orb.scale.x = side
	
func unite_following_orbs(): 
	can_update_following_orbs = false
	if following_orbs.is_empty():
		return

	var target_node = get_parent().find_child("OrbUniteTarget") 

	if not is_instance_valid(target_node):
		printerr("Nó 'OrbUniteTarget' não foi encontrado na cena Fim!")
		return

	var target_position = target_node.global_position 
	var duration = 1.5

	for orb in following_orbs:
		var tween = create_tween()
		tween.tween_property(orb, "global_position", target_position, duration).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(orb, "modulate:a", 0.0, 0.2).set_delay(duration - 0.2)
