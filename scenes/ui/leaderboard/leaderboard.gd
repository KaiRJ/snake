class_name Leaderboard
extends Control

@onready var title_label: Label = %TitleLabel
@onready var enter_name_container: HBoxContainer = %EnterNameContainer
@onready var name_input: LineEdit = %NameInput

@onready var first_name: Label = %FirstName
@onready var first_score: Label = %FirstScore
@onready var second_name: Label = %SecondName
@onready var second_score: Label = %SecondScore
@onready var third_name: Label = %ThirdName
@onready var third_score: Label = %ThirdScore
@onready var fourth_name: Label = %FourthName
@onready var fourth_score: Label = %FourthScore
@onready var fith_name: Label = %FithName
@onready var fith_score: Label = %FithScore

var leaderboard: SavedLeaderboard
var new_score: int


func _ready() -> void:
	if ResourceLoader.exists(GameEvents.LEADERBOARD_FILE):
		leaderboard = load(GameEvents.LEADERBOARD_FILE)
	else:
		leaderboard = SavedLeaderboard.new()
	
	load_leaderboard()


func pass_score(score: int) -> void:
	if score < int(fith_score.text):
		return
	
	title_label.text = "New highscore!"
	new_score = score
	enter_name_container.show()


func load_leaderboard() -> void:
	first_name.text = "1. " + leaderboard.leaderboard[0][0]
	first_score.text = str(leaderboard.leaderboard[0][1])
	second_name.text = "2. " + leaderboard.leaderboard[1][0]
	second_score.text = str(leaderboard.leaderboard[1][1])
	third_name.text = "3. " + leaderboard.leaderboard[2][0]
	third_score.text = str(leaderboard.leaderboard[2][1])
	fourth_name.text = "4. " + leaderboard.leaderboard[3][0]
	fourth_score.text =str(leaderboard.leaderboard[3][1])
	fith_name.text = "5. " + leaderboard.leaderboard[4][0]
	fith_score.text = str(leaderboard.leaderboard[4][1])


func _on_enter_button_pressed() -> void:
	enter_name_container.hide()
	
	for i: int in range(len(leaderboard.leaderboard)):
		if new_score > leaderboard.leaderboard[i][1]:
			leaderboard.leaderboard.insert(i, [name_input.text, new_score])
			break
	
	leaderboard.leaderboard.pop_back()
	load_leaderboard()

func _on_quit_button_pressed() -> void:
	ResourceSaver.save(leaderboard, GameEvents.LEADERBOARD_FILE)
	GameEvents.quit_game()


func _on_clear_button_pressed() -> void:
	leaderboard = SavedLeaderboard.new()
	load_leaderboard()
