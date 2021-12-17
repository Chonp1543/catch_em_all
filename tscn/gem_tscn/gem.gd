extends Area2D

func _ready() -> void:
#	efecto de escalado X 3
	$Tween.interpolate_property(
		$AnimatedSprite,
		"scale",
		$AnimatedSprite.scale,
		$AnimatedSprite.scale * 3,
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
#	efecto de desvanecimiento
	$Tween.interpolate_property(
		$AnimatedSprite,
		"modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)

func pickup() -> void:
	$Tween.start()
#	para que se ejecute la interpolacion del Tween
	yield($Tween, "tween_completed")
	call_deferred("queue_free")



func _on_gem_area_entered(area : Area2D) -> void:
	if area.is_in_group("enemy"):
		self.position.x = rand_range(35,470)
		self.position.y = rand_range(35,600)
