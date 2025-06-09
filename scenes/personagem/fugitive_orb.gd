extends Node2D

@onready var sprite = $AnimatedSprite2D

func setup():
	sprite.play("default")

# Este orb não tem lógica de colisão ou coleta
