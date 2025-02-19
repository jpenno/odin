package game

import conf "../config"
import "core:strings"
import rl "vendor:raylib"

Game_State :: enum {
	PLAYING,
	PAUSED,
	RESTE,
	OVER,
	QUIT,
}

Game :: struct {
	player: Player,
	state:  Game_State,
}

@(private = "file")
game: Game = Game{}

game_err :: enum {
	nil,
}

init :: proc() -> game_err {
	game = Game {
		player = player_init(),
		state  = .PAUSED,
	}
	return nil
}

update :: proc() -> Game_State {
	dt := rl.GetFrameTime()
	switch game.state {
	case .PAUSED:
		if rl.IsKeyPressed(.SPACE) {
			game.state = .PLAYING
		}
		if rl.IsKeyPressed(.ESCAPE) {
			game.state = .QUIT
		}
	case .PLAYING:
		if rl.IsKeyPressed(.ESCAPE) {
			game.state = .PAUSED
		}
		if game.player.dead {
			game.state = .OVER
		}
		player_update(&game.player, dt)
	case .OVER:
		if rl.IsKeyPressed(.R) {
			game.state = .RESTE
		}
		if rl.IsKeyPressed(.ESCAPE) {
			game.state = .QUIT
		}
	case .RESTE:
		init()
		game.state = .PLAYING
	case .QUIT:
	}

	return game.state
}

draw :: proc() {
	#partial switch game.state {
	case .PAUSED:
		drawCenteredList({"Pused", "Press space to play", "Press escape to quit"}, rl.GREEN, 32)
	case .PLAYING:
		player_draw(game.player)
	case .OVER:
		drawCenteredList({"Game over", "Press r to play", "Press escape to quit"}, rl.RED, 32)
	case .QUIT:
	}
}

drawCenteredList :: proc(list: []cstring, color: rl.Color, text_size: i32) {
	item_len := i32(len(list))

	i: i32 = 0
	for item in list {
		text_len := rl.MeasureText(item, text_size) / 2

		x := conf.SCREEN_WIDTH / 2 - text_len
		y := (conf.SCREEN_HEIGHT / 2) + (text_size * i)
		y -= text_size * item_len / 2

		rl.DrawText(item, x, y, text_size, color)
		i += 1
	}
}
