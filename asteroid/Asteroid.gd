extends "res://weightless/Weightless.gd"

var AsteroidSmall = load("res://asteroid/AsteroidSmall.tscn") as PackedScene
var AsteroidMedium = load("res://asteroid/AsteroidMedium.tscn") as PackedScene

signal explode

enum Size {
	SMALL, MEDIUM, LARGE
}

export (float) var explode_dir = 300 
export (Size) var size = Size.LARGE
var radius

func _ready():
	connect("explode", self, "_explode")
	bounce = 0.5
	friction = 1
	radius = get_node("Sprite").texture.get_width() / 2 * get_node("Sprite").scale
	pass
	
func _explode():
	if size != Size.SMALL:
		for i in range(0, 3):
			var offset_dir = PI * 2 / 3 * i
			var asteroid
			match size:
				Size.MEDIUM:
					asteroid = AsteroidSmall.instance()
				Size.LARGE:
					asteroid = AsteroidMedium.instance()
		
			asteroid.position = position + radius.rotated(offset_dir)
			asteroid.linear_velocity = linear_velocity + Vector2(explode_dir, 0).rotated(offset_dir)
			get_parent().add_child(asteroid)
		
	queue_free()
	sleeping = true
	pass