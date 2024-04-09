extends CharacterBody2D

var speed = 37
var perseguir = false
var pola = null
var health = 100
var player_inattack_zone = false

func _physics_process(delta):
	deal_with_damange()
	
	if perseguir:
		position += (pola.position - position)/speed
		
		$AnimatedSprite2D.play("default")
		if(pola.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_deteccion_body_entered(body):
	pola = body
	perseguir = true


func _on_deteccion_body_exited(body):
	pola = null
	perseguir = false

func murcielago():
	pass


func _on_hitbox_bat_body_entered(body):
	if body.has_method("pola"):
		player_inattack_zone = true


func _on_hitbox_bat_body_exited(body):
	if body.has_method("pola"):
		player_inattack_zone = false
		
func deal_with_damange():
	if player_inattack_zone and global.player_current_attack == true:
		health = health -20
		print("murcielago health =", health)
		if health <=0:
			self.queue_free()
