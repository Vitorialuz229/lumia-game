extends Area2D

@export var orb_type: String = "vazio"
var is_collected = false
@onready var sprite = $AnimatedSprite2D
@onready var sound = $CollectSound

func _ready():
	sprite.play(orb_type)
	if orb_type == "vazio":
		is_collected = true
		$CollisionShape2D.disabled = true

func _on_body_entered(body):
	if body.name == "Cynthia" and not is_collected and is_instance_valid(body):
		collect(body)

func collect(player):
	is_collected = true
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Efeitos visuais e sonoros
	sound.play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	
	# Registra no sistema de save
	Globals.register_orb(orb_type, global_position)
	
	# Cria uma nova instância para seguir o jogador
	var new_orb = preload("res://scenes/personagem/orb.tscn").instantiate()
	new_orb.orb_type = orb_type
	new_orb.is_collected = true
	new_orb.get_node("CollisionShape2D").disabled = true
	
	# Adiciona ao jogador imediatamente
	player.call_deferred("add_following_orb", new_orb)
	
	await tween.finished
	queue_free()
