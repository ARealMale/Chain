extends CharacterBody2D
class_name Player

@onready var animate = $AnimatedSprite2D
@onready var dashSound = $DashSfx
var coyote = 0
var accel = 20
var jump = -800
var dashPower = 800
var dash_charged = true
var dashing_time = 0
var running = false
var last_direction = Vector2(0, 0)

func _ready():
	Global.player = self

func swap_animation(new : String):
	if animate.animation != new:
		animate.play(new)

func do_animation():
	if (dashing_time > 0):
		if animate.animation != "apex_enter_dash" and animate.animation != "dash":
			swap_animation("apex_enter_dash")
	else:
		if (coyote > 0):
			# Grounded
			if animate.animation == "dash":
				swap_animation("apex_enter_dash")
			elif animate.animation == "fall":
				swap_animation("land")
			elif animate.animation != "land" and animate.animation != "apex_enter_dash":
				if (running):
					swap_animation("run")
				else:
					swap_animation("idle")
		else:
			# In air
			if (velocity.y > 10):
				swap_animation("fall")
			elif (velocity.y < -10):
				swap_animation("rise")
			else:
				swap_animation("apex_enter_dash")				

func reset():
	self.position.x = 0
	self.position.y = 0
	self.velocity.x = 0
	self.velocity.y = 0

func move():
	Global.cameraX += (position.x-Global.cameraX)*0.2
	Global.cameraY += (position.y-Global.cameraY)*0.2
	var velocity_before_collision = velocity
	move_and_slide()
	for i in get_slide_collision_count():
		var collided = get_slide_collision(i)
		var collider = collided.get_collider()
		if collider.name == "WallComponent":
			var new = abs(velocity_before_collision.x)
			var newHealth = collider.resistance -  new
			if newHealth < collider.health:
				collider.health = newHealth
		if collider.name == "FloorComponent":
			collider.crumble = true

func controls(grip : int, delta : float):
	var dash_direction = Input.get_vector("left", "right", "up", "down")
	if dash_direction.length() != 0:
		last_direction = dash_direction
	var dir = Input.get_axis("left", "right")
	velocity.x += dir * grip * delta * 100
	if dir > 0:
		$AnimatedSprite2D.flip_h = false
		running = true
	elif dir < 0:
		$AnimatedSprite2D.flip_h = true
		running = true
	else:
		running = false
	if dash_charged:
		self.modulate = Color(1, 1, 1, 1)
	else:
		if dashing_time > 0:
			self.modulate = Color(0.8, 1, 1, 1)
		else:
			self.modulate = Color(1, 0.7, 0.7, 1)
	if Input.is_action_just_pressed("up") and coyote > 0:
		velocity.y = jump
		coyote = 0
	if Input.is_action_just_pressed("space") and dash_charged:
		dashSound.play()
		velocity += last_direction * dashPower
		dash_charged = false
		dashing_time = 0.5

func _physics_process(delta: float) -> void:
	if self.position.y > 500 or self.position.y < -600:
		reset()
	velocity += get_gravity() * delta * 2
	if dashing_time > 0:
		dashing_time -= delta
		if dashing_time < 0:
				dashing_time = 0
	if is_on_floor():
		velocity.x -= velocity.x * delta * 5
		coyote = 0.2
		if dashing_time == 0:
			dash_charged = true
		accel = 20
	else:
		accel = 5
		if coyote > 0:
			coyote -= delta
			if coyote < 0:
				coyote = 0
	controls(accel, delta)
	do_animation()
	move()
	


func _on_spikes_body_entered(body: Node2D) -> void:
	if body is Player:
		reset()


func _on_animated_sprite_2d_animation_looped() -> void:
	if animate.animation == "apex_enter_dash" and dashing_time > 0:
		swap_animation("dash")
	if animate.animation == "apex_enter_dash":
		swap_animation("land")
	elif animate.animation == "land":
		if (running):
			swap_animation("run")
		else:
			swap_animation("idle")
