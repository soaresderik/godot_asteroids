extends "res://weightless/Weightless.gd"

var Missile = preload("res://missile/Missile.tscn")

export (float) var engine_thrust = 200
export (float) var spin_thrust = 2000
export (float) var missile_speed = 300
export (float) var recharge_time = .2

var thrust = Vector2()
var rot_dir = 0
var recharge_timer = 0

func _ready():
	friction = 0.2
	
func _process(delta):
	if Input.is_action_pressed("player_up"):
		thrust = Vector2(engine_thrust, 0)
	else:
		thrust = Vector2()

	if Input.is_action_pressed("player_left"):
		rot_dir = -1
	elif Input.is_action_pressed("player_right"):
		rot_dir = 1
	else:
		rot_dir = 0
		
	if Input.is_action_pressed("player_shoot"):
		if recharge_timer <= 0:
			for offset in [Vector2(15, -45 / 2), Vector2(15, 45 / 2)]:
				var missile = Missile.instance()
				missile.position = position + offset.rotated(rotation)
				missile.rotation = rotation
				missile.linear_velocity = linear_velocity + Vector2(missile_speed, 0).rotated(rotation)
				get_parent().add_child(missile)
			recharge_timer = recharge_time
		else:
			recharge_timer -= delta
	pass

func _integrate_forces(state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rot_dir * spin_thrust)
	._integrate_forces(state)
	pass