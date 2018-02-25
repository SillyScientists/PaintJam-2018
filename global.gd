extends Node

onready var current_scene = null
var money = 30
var first_scene = true
var env_scene = preload("res://scenes/world/env.tscn")
var main_scene = preload("res://scenes/main/main.tscn")
var hub_scene = preload("res://scenes/hub/hub.tscn")

func _ready():
	print("Loaded!")