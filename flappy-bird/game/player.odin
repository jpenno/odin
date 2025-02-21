package game

import "../file_io"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:sort"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

Player :: struct {
	rect:          rl.Rectangle,
	color:         rl.Color,
	velocity:      rl.Vector2,
	gravity:       f32,
	gravity_acell: f32,
	jump_force:    f32,
	dead:          bool,
	score:         int,
	highscores:    [10]int,
}

player_init :: proc() -> Player {
	return Player {
		rect = rl.Rectangle{x = 100, y = 100, width = 100, height = 100},
		color = rl.BLUE,
		gravity = 500,
		gravity_acell = 3_500,
		jump_force = -800,
	}
}

player_update :: proc(p: ^Player, pipes: [10]Pipe, dt: f32) -> bool {
	if p.velocity.y < p.gravity {
		p.velocity.y += p.gravity_acell * dt
	} else {
		p.velocity.y = p.gravity
	}

	if rl.IsKeyPressed(.SPACE) {
		p.velocity.y = p.jump_force
	}

	p.rect.y += p.velocity.y * dt

	if p.rect.y < 0 {
		player_die(p)
	}
	if p.rect.y > f32(rl.GetScreenHeight()) {
		player_die(p)
	}

	for pipe in pipes {
		if rl.CheckCollisionRecs(p.rect, pipe.rect) {
			player_die(p)
			break
		}
	}

	return p.dead
}

player_draw :: proc(p: Player) {
	rl.DrawRectangleRec(p.rect, p.color)
}

player_draw_highscores :: proc(p: Player) {
	highscors_str := make([]string, 10)
	for s, i in p.highscores {
		highscors_str[i] = fmt.aprintf("%d: %d", i + 1, s)
	}

	draw_centered_list(highscors_str, rl.BLUE, 32, .TOP)
}

player_die :: proc(p: ^Player) {
	p.dead = true
	player_save_score(p)
}

player_draw_score :: proc(p: Player) {
	score_text := fmt.aprintfln("Score: %d", p.score)
	score_len := len(score_text)
	draw_centered_list({score_text}, rl.SKYBLUE, 32, .TOP)
}

player_save_score :: proc(p: ^Player) {
	filepath := "highscores.txt"

	p.highscores = file_io.get_highscores(filepath)

	slice.reverse_sort(p.highscores[:])

	new_score_index: int = -1
	for score, i in p.highscores {
		if p.score > score {
			p.highscores[i] = p.score
			break
		}
	}

	file_io.save_highscores(filepath, p.highscores)
}
