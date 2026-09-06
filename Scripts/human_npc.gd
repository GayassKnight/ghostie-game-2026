extends CharacterBody2D
class_name StateMachineSimple

#Export variables
@export var destinations:Array[Marker2D]

#Onready variables
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

#Regular variables
enum HumanStates {IDLE, WALKING, POSSESED}
var current_state = HumanStates.IDLE
