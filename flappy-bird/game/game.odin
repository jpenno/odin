package game

import conf "../config"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

Game_State :: enum {
	PLAYING,
	PAUSED,
	RESET,
	OVER,
	QUIT,
}

Game :: struct {
	player:           Player,
	state:            Game_State,
	pipes:            [10]Pipe,
	pipe_spawn_timer: f32,
	pipe_spawn_time:  f32,
}

@(private = "file")
game: Game = Game{}

game_err :: enum {
	nil,
}

init :: proc() -> game_err {
	game = Game {
		player          = player_init(),
		state           = .PAUSED,
		pipe_spawn_time = 2.0,
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
		playing_update(dt)
	case .OVER:
		if rl.IsKeyPressed(.R) {
			game.state = .RESET
		}
		if rl.IsKeyPressed(.ESCAPE) {
			game.state = .QUIT
		}
	case .RESET:
		init()
		game.state = .PLAYING
	case .QUIT:
	}

	return game.state
}

draw :: proc() {
	#partial switch game.state {
	case .PAUSED:
		draw_centered_list({"Pused", "Press space to play", "Press escape to quit"}, rl.GREEN, 32)
	case .PLAYING:
		player_draw(game.player)
		for p in game.pipes {
			pipe_draw(p)
		}
		score_text := fmt.aprintfln("Score: %d", game.player.score)
		score_len := len(score_text)
		draw_centered_list({score_text}, rl.SKYBLUE, 32, .TOP)
	case .OVER:
		draw_centered_list({"Game over", "Press r to play", "Press escape to quit"}, rl.RED, 32)
	case .QUIT:
	}
}

@(private = "file")
playing_update :: proc(dt: f32) {
	if rl.IsKeyPressed(.ESCAPE) {
		game.state = .PAUSED
	}
	if game.player.dead {
		game.state = .OVER
	}

	player_update(&game.player, dt)

	for &p in game.pipes {
		pipe_update(&p, dt)
	}

	for &p in game.pipes {
		if rl.CheckCollisionRecs(game.player.rect, p.rect) {
			game.state = .OVER
		}
	}

	game.pipe_spawn_timer -= dt
	if game.pipe_spawn_timer <= 0 {
		spawn_pipes()
		game.pipe_spawn_timer = game.pipe_spawn_time
	}
}

spawn_pipes :: proc() {
	pipes := pipe_spawn_pair()

	for new_pipe in pipes {
		for &p in game.pipes {
			if p.active == false {
				p = new_pipe
				break
			}
		}
	}
}

Align_text :: enum {
	CENTER,
	TOP,
}

@(private = "file")
draw_centered_list :: proc(
	list: []string,
	color: rl.Color,
	text_size: i32,
	align: Align_text = .CENTER,
) {
	item_len := i32(len(list))

	i: i32 = 0
	for item in list {
		cstr := strings.clone_to_cstring(item)
		defer delete(cstr)

		text_len := rl.MeasureText(cstr, text_size) / 2

		y: i32
		x := conf.SCREEN_WIDTH / 2 - text_len
		switch align {
		case .CENTER:
			y = (conf.SCREEN_HEIGHT / 2) + (text_size * i)
		case .TOP:
			y = text_size
		}
		y -= text_size * item_len / 2

		rl.DrawText(cstr, x, y, text_size, color)
		i += 1
	}
}
