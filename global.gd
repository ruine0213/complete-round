extends Node


enum GameState {title, game, pause, result}
var current_state:GameState

var time

var target

enum targetType {neutral, enemy, ally}

var player

var score

var player_hp
