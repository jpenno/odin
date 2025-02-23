package game

import c "../config"
import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

Game_State :: enum {
	START,
	PLAYING,
	PAUSED,
	RESET,
	OVER,
	QUIT,
}

Game :: struct {
	rect:             rl.Rectangle,
	state:            Game_State,
	boxes:            [100]Box,
	box_timer:        Timer,
	box_spawn_amount: int,
	player:           Player,
}

@(private = "file")
game: Game = Game{}

init :: proc() {
	game = Game {
		state            = .PLAYING,
		box_timer        = timer_init(1.5),
		box_spawn_amount = 1,
		player           = player_init(),
	}
}

quit :: proc() {

}

@(private)
input :: proc() {
	if rl.IsKeyDown(rl.KeyboardKey.ESCAPE) {
		game.state = .QUIT
	}
}

update :: proc() -> Game_State {
	dt := rl.GetFrameTime()

	input()

	switch game.state {
	case .START:
	case .RESET:
	case .PLAYING:
		game_update_playing(dt)
	case .PAUSED:
	case .OVER:
	case .QUIT:
	}

	return game.state
}

game_update_playing :: proc(dt: f32) {
	if timer_tick(&game.box_timer, dt) == Timer_state.DONE {
		for _ in 0 ..< game.box_spawn_amount {
			for &b in game.boxes {
				if !b.active {
					b = box_spawn(Spawn_direction(rand.choice_enum(Spawn_direction)))
					break
				}
			}
		}
	}

	for &box in game.boxes {
		box_update(&box, dt)
	}

	switch player_update(&game.player, dt) {
	case Player_action.ATTACK:
		for &box in game.boxes {
			if rl.CheckCollisionRecs(
			rl.Rectangle { 	// box
				x      = box.pos.x,
				y      = box.pos.y,
				width  = box.size.x,
				height = box.size.y,
			},
			rl.Rectangle { 	// player
				x      = game.player.pos.x,
				y      = game.player.pos.y,
				width  = game.player.size.x,
				height = game.player.size.y,
			},
			) {
				box.active = false
				game.player.score += 1
			}
		}
	case Player_action.NONE:
	}
}

draw :: proc() {
	rl.ClearBackground(rl.GRAY)
	rl.DrawText(fmt.ctprintfln("FPS: %d", rl.GetFPS()), 10, 10, 32, rl.GREEN)

	switch game.state {
	case .START:
	case .RESET:
	case .PLAYING:
		game_draw_playing()
	case .PAUSED:
	case .OVER:
	case .QUIT:
	}
}

game_draw_playing :: proc() {
	for &box in game.boxes {
		box_draw(box)
	}

	player_draw(game.player)

	rl.DrawText(
		fmt.ctprintfln("Score: %d", game.player.score),
		rl.GetScreenWidth() / 2,
		10,
		32,
		rl.GREEN,
	)
}
