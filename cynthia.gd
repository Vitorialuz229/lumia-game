extends CharacterBody2D

var speed = 300
var jump_force = -600
var gravity = 1500

func _ready():
	$Camera2D.make_current()  # Garante que a câmera siga a personagem

func _physics_process(delta):
	# Debug simplificado (só exibe se houver movimento)
	if velocity.x != 0 or velocity.y != 0:
		print("Velocity: ", velocity, " | No chão: ", is_on_floor())
	
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Movimento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	
	# Pulo
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
	
	move_and_slide()
