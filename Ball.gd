extends RigidBody2D

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	gravity_scale = 10.0


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	gravity_scale = 1.0
