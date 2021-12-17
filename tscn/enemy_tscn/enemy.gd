extends KinematicBody2D

const SPEED = 200

onready var raycast = $RayCast2D
var vec_to_player
var player = null
var velocity = Vector2.ZERO

#variables de la maquina de estados
enum {IDLE, BREATHE, JUMP}
var state
var current_anim
var new_anim



func _ready():
	randomize()
	set_timer_interval()
	transition_to(IDLE)
	
	
#Maquina de estados
func transition_to(new_state):
	state = new_state
	match (state):
		IDLE:
			new_anim = "idle"
		BREATHE:
			new_anim = "breathe"
		JUMP:
			new_anim = "jump"
	
	
func _process(delta):
	if new_anim != current_anim:
		current_anim = new_anim
		$AnimationPlayer.play(current_anim)
	
	
	
func _physics_process(delta):
	
	if player == null:
		return
	
	vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player":
			coll.game_over()
			move_and_collide(vec_to_player * SPEED * delta)
	
	"""
	if not is_on_floor():
		velocity.x = speed
	else:
		velocity.x = 0
		todo este codigo es innecesario
	if velocity.x > 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	$Sprite.flip_h = (speed > 0)
		"""

func set_timer_interval():
#	Timer de breathe
	var interval = rand_range(1,3)
	$Timer.wait_time = interval
	$Timer.start()




func _on_Timer_timeout():
	$Timer.stop()
	if state == IDLE:
		transition_to(BREATHE)
#	$AnimationPlayer.play("idle")
	set_timer_interval()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "breathe":
		transition_to(IDLE)

	"""
func update_speed_direction():
	este codigo es mas facil si aplico el operador ternario
	var pulso = bool(randi() % 2)
	if pulso:
		speed = speed * 1
	else:
		speed = speed * -1
	speed = speed * 1 if bool(randi() % 2) else speed * -1
	"""
	

