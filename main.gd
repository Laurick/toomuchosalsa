extends Node2D

var score = 0
var balance_score = 0




#TODO ver tema puntuaciones

func fail():
	balance_score -= 1
	

func success():
	balance_score +=1
	score = score + (balance_score)
