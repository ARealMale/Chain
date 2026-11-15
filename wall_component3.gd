extends StaticBody2D
@onready var breakSound = $WallBreak
@onready var main = Global
@onready var animate = $AnimatedSprite2D
var resistance = 3600
var health = resistance
var breaking = false

func _physics_process(delta: float) -> void:
	animate.play(Global.animate)
	if health > 0:
		if health < resistance:
			health += resistance * delta / 4
			if health > resistance:
				health = resistance
		self.modulate = Color(health/resistance, health/resistance, health/resistance, 1)
	else:		
		if not breaking:
			breakSound.play()
			if main is global_class:
				main.stage = 4
				main.flash = 2
			breaking = true
		else:
			if not breakSound.playing: queue_free()
		$WallCollider.set_deferred("disabled", true)
		self.visible = false
