extends AnimatedSprite2D
@onready var animate = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	modulate = Color(1, 1, 1, Global.stage/2)
