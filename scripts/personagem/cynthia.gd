extends CharacterBody2D

var speed = 300
var jump_force = -600
var gravity = 1500

@onready var sprite = $AnimatedSprite2D

#func _ready():
	# $Camera2D.make_current()  # fazer a câmera seguir a personagem

func _physics_process(delta):
	# Aplica gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Movimento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	
	# Pulo
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
	
	# Move o personagem
	move_and_slide()

	# Controle das animações
	if not is_on_floor():
		sprite.play("jump")
	elif abs(velocity.x) > 0.1:
		sprite.play("run")
	else:
		sprite.play("idle")
	
	# Virar o sprite para o lado
	if direction != 0:
		sprite.flip_h = direction < 0
