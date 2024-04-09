extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var pola_alive = true

var attack_ip = false

const SPEED = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")


func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		pola_alive = false
		health = 0
		print("Se murio la pola")
		self.queue_free()
		
func player_movement(delta):
	if Input.is_action_pressed("derecha"):
		current_dir = "derecha"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("izquierda"):
		current_dir = "izquierda"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("abajo"):
		current_dir = "abajo"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("arriba"):
		current_dir = "arriba"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED
		
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0


	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "derecha":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "izquierda":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")

	if dir == "abajo":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "arriba":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")
	

func pola():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("murcielago"):
		enemy_inattack_range = true


func _on_area_2d_body_exited(body):
	if body.has_method("murcielago"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("ataque"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "derecha":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "izquierda":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "abajo":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "arriba":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
			


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false 
	attack_ip = false
