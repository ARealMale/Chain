extends Area2D
@onready var animate = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	animate.play(Global.animate)

func _on_body_entered(body: Node2D) -> void:
	Global.player.reset()
