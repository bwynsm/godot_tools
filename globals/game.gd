extends Node


# if signal is emitted for scene change, we want to change the scene and update location.
onready var CURRENT_SCENE

func _ready():
	GlobalSignals.add_listener("change_scene", self, "_on_Change_Scene")
	CURRENT_SCENE = get_tree().get_current_scene()


func _hide_canvas_layers(scene: Node):
	for child in scene.get_children():
		if child is CanvasLayer:
			print(child.name + " - " + child.get_class())
			child.scale = Vector2(0, 0)
		if child.get_child_count() > 0:
			_hide_canvas_layers(child)
		if child is Camera2D:
			child.current = false


func _show_canvas_layers(scene: Node2D):
	for child in scene.get_children():
		if child is CanvasLayer:
			child.scale = Vector2(1, 1)


func _on_Change_Scene(new_scene: String, _remove_scene: bool, move_player: bool) -> void:
	var root = get_tree().get_root()
	var next_scene = (load(new_scene) as PackedScene).instance()
	var player = CURRENT_SCENE.get_node("Player")
	var current_scene = CURRENT_SCENE

	# add the next scene to the root 
	# now we have two scenes attached to root so we'll need to cleanup
	root.call_deferred("add_child", next_scene)

	if move_player:
		# remove from the old scene
		current_scene.remove_child(player)
		next_scene.add_child(player)
	

	# cleanup and switch
	#if remove_scene:
	root.remove_child(current_scene)
	current_scene.queue_free()
	#else:
	#	current_scene.pause_mode = Node2D.PAUSE_MODE_PROCESS
	#	root.move_child(next_scene, 0)
	#	current_scene.visible = false
	#	_hide_canvas_layers(current_scene)

	# update our reference point
	CURRENT_SCENE = next_scene

	print("Done transitioning scene")

	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

	
func delete_items_in_group(group):
	for group_item in get_tree().get_nodes_in_group(group):
		group_item.queue_free()
