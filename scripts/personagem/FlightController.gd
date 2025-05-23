extends Node

var speed := randf_range(40, 70)
var direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
var change_dir_timer := randf_range(1, 3)
var screen_limits = Rect2(0, 0, 3000, 641) # Mudar o limite da direita depois

func _process(delta):
	change_dir_timer -= delta
	if change_dir_timer <= 0:
		direction = direction.rotated(randf_range(-0.5, 0.5))
		change_dir_timer = randf_range(1, 3)
	
	get_parent().position += direction * speed * delta
	
	if abs(direction.x) > 0.1:
		get_parent().get_node("AnimatedSprite2D").flip_h = direction.x < 0
		
	# Limita a área de movimento
	var new_pos = get_parent().position + (direction * speed * delta)
	new_pos.x = clamp(new_pos.x, screen_limits.position.x, screen_limits.end.x)
	new_pos.y = clamp(new_pos.y, screen_limits.position.y, screen_limits.end.y)
	get_parent().position = new_pos
	
	# Inverte direção ao chegar nos limites
	if get_parent().position.x <= screen_limits.position.x or get_parent().position.x >= screen_limits.end.x:
		direction.x *= -1
	if get_parent().position.y <= screen_limits.position.y or get_parent().position.y >= screen_limits.end.y:
		direction.y *= -1
