class_name UpgradePanel extends Node2D

@onready var healthContainer = $GridContainer/Health
@onready var armorContainer = $GridContainer/Armor
@onready var movementContainer = $GridContainer/Movement
@onready var speedContainer = $GridContainer/Speed
@onready var attackContainer = $GridContainer/Attack
@onready var action1Container = $GridContainer/Action1
@onready var action2Container = $GridContainer/Action2

func _ready():
    healthContainer.get_child(0)
