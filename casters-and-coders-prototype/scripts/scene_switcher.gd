extends Node

var current_scene: Node = null
var next_scene : Node = null

# semaphore to lock the scene changer while it's transitioning
var transitioning = false

# The animation player
onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	anim.connect("animation_finished", self, "_on_animation_finished")

func change_scene(next_scene_path: String) -> int:
	if transitioning:
		print("cannot change scene to " + next_scene_path + " while scene change animation is playing")
		return ERR_BUSY
	transitioning = true
	# TODO: maybe take a PackedScene argument so scenes could be preloaded for performance
	var loaded_scene = load(next_scene_path)
	if loaded_scene == null:
		print("can't find scene: " + next_scene_path)
		transitioning = false
		return ERR_FILE_BAD_PATH
	next_scene = load(next_scene_path).instance()
	anim.play("fade_in")
	return OK

func _on_animation_finished(anim_name: String):
	if anim_name == "fade_in":
		if current_scene != null:
			current_scene.queue_free()
		get_tree().root.add_child(next_scene)
		current_scene = next_scene
		next_scene = null
		anim.play("fade_out")
		transitioning = false
