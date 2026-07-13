scoreboard objectives remove meccha.scoring
scoreboard objectives remove meccha.scoring_public

scoreboard objectives add meccha.scoring dummy

scoreboard objectives add meccha.scoring_public dummy
scoreboard objectives modify meccha.scoring_public displayname {"text":"Score"}
scoreboard objectives setdisplay sidebar meccha.scoring_public