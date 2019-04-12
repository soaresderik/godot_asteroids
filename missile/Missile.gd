extends RigidBody2D

onready var viewport = get_viewport().get_visible_rect()

func _ready():
	set_max_contacts_reported(1)
	pass

func _process(delta):
	if not viewport.has_point(position):
		queue_free()

func _integrate_forces(state):
	var contacts = state.get_contact_count()
	for i in range(contacts):
		var contact = state.get_contact_collider_object(i)
		if contact.get_script().has_script_signal("explode"):
			contact.emit_signal("explode")
			queue_free()
			sleeping = true
	pass