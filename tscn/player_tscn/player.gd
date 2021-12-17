extends Area2D

signal hurt
signal picked

var velocity : Vector2 = Vector2.ZERO
export onready var speed : int = 350

func _ready() -> void:
	OS.center_window()
	position = Vector2(100,100)

func _process(delta : float) -> void:
#	movimiento del personaje
	movement()
	position += velocity * delta

#	limites del viewport
	position.x = clamp(position.x, 0, 480)
	position.y = clamp(position.y, 0, 620)
	"""
	clamp() funciona igual que todo este codigo pero mas resumido
	if position.x >= 480:
		position.x = 480
	if position.x <= 0:
		position.x = 0
	if position.y >= 620:
		position.y = 620
	if position.y <= 0:
		position.y = 0
	"""

#	animacion del personaje
	process_animations()

func movement() -> void:

	#	movimiento del personaje
	velocity = Vector2.ZERO
	if Input.is_action_pressed("wasd_up"):
		velocity.y -= 1
	if Input.is_action_pressed("wasd_down"):
		velocity.y += 1
	if Input.is_action_pressed("wasd_right"):
		velocity.x += 1
	if Input.is_action_pressed("wasd_left"):
		velocity.x -= 1

#	normalizar la velocidad del personaje
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func process_animations() -> void:
	#	animacion del personaje
	if velocity.length() != 0:
#		velocity.length() hace referencia a los ejes (x , y)
#		get_node("AnimatedSprite").play("run") es lo mismo que $AnimatedSprite.play("run")
		$AnimatedSprite.play("run")
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.play("idle")

func _on_player_area_entered(area : Area2D) -> void:
#	detectar si el jugador colisiona con la gema
	if area.is_in_group("gem"):
		$gemaudio.play()
		emit_signal("picked", "gem")
	elif area.is_in_group("cherry"):
		$poweupaudio.play()
		emit_signal("picked", "cherry")

	if area.has_method("pickup"):
		area.pickup()

func game_over() -> void:
	set_process(false)
	$AnimatedSprite.animation = "hurt"


func _on_player_body_entered(body : KinematicBody2D) -> void:
	if body.is_in_group("enemy"):
		emit_signal("hurt")
