package game

import rl "vendor:raylib"

Game :: struct {
	player: Player,
}

@(private = "file")
game: Game = Game{}

game_err :: enum {
	nil,
}

init :: proc() -> game_err {
	game = Game {
		player = player_init(),
	}
	return nil
}

update :: proc() {
	dt := rl.GetFrameTime()

	player_update(&game.player, dt)
}

draw :: proc() {
	player_draw(game.player)
}
