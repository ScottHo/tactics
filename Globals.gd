extends Node

var current_scene = null

var entities_to_deploy = []
var level_debug_mode = true
var current_mission: Mission
var current_recruit: int = -1
var bots_collected := []
var bots_dead := []
var skill_points := 1
var entity_skill_point_distributions: Dictionary
var current_level := 1
var current_foundry := "None"
var missions_found := false
var mission_options := []
var recruit_options := []
var in_action := false
var in_move := false
var on_ui := false



static var UNKNOWN_BOT_ICON_PATH = "res://Assets/Unknown.png"
static var NO_BOT_ICON_PATH = "res://Assets/None.png"

func reset():
    entities_to_deploy= []
    current_recruit = -1
    bots_collected = []
    bots_dead = []
    skill_points = 1
    entity_skill_point_distributions = {}
    current_level = 1
    current_foundry = "None"
    missions_found = false
    mission_options = []
    recruit_options = []
    in_action = false
    in_move = false
    on_ui = false
    return

func start_action(move: bool):
    in_action = true
    if move:
        in_move = true
    return

func end_action():
    in_action = false
    in_move = false
    return

func _ready():
    var root = get_tree().root
    current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function in the current scene.
    # Deleting the current scene at this point is
    # a bad idea, because it may still be executing code.
    # This will result in a crash or unexpected behavior.

    # The solution is to defer the load to a later time, when
    # we can be sure that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
    # It is now safe to remove the current scene.
    current_scene.free()

    # Load the new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instantiate()

    # Add it to the active scene, as child of root.
    get_tree().root.add_child(current_scene)

    # Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
    get_tree().current_scene = current_scene
