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

	for &p in game.pipes {
		p.state = .UNACTIVE
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
		player_draw_score(game.player)
	case .OVER:
		player_draw_highscores(game.player)
		player_score_str := fmt.aprintf("Scero: %d", game.player.score)
		draw_centered_list(
			{player_score_str, "Game over", "Press r to play", "Press escape to quit"},
			rl.RED,
			32,
		)
	case .QUIT:
	}
}

@(private = "file")
playing_update :: proc(dt: f32) {
	if rl.IsKeyPressed(.ESCAPE) {
		game.state = .PAUSED
		return
	}
	if game.player.dead {
		game.state = .OVER
		return
	}

	player_update(&game.player, game.pipes, dt)

	for &p in game.pipes {
		pipe_update(&p, &game.player, dt)
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
			if p.state == .UNACTIVE {
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

draw_centered_list :: proc(
	list: []string,
	color: rl.Color,
	text_size: i32,
	align: Align_text = .CENTER,
) {
	item_len := i32(len(list))

	y: i32
	switch align {
	case .CENTER:
		y = (conf.SCREEN_HEIGHT / 2) + (text_size)
	case .TOP:
		y = 10
	}

	for item, i in list {
		cstr := strings.clone_to_cstring(item, context.temp_allocator)

		text_len := rl.MeasureText(cstr, text_size) / 2

		x := conf.SCREEN_WIDTH / 2 - text_len
		rl.DrawText(cstr, x, y, text_size, color)

		y += text_size
	}
}
