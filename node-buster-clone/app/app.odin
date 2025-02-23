package app

import c "../config"
import "../game"
import rl "vendor:raylib"

State :: enum {
	RUNNING,
	QUIT,
}

App :: struct {
	state: State,
}

@(private)
app := App{}

init :: proc() {
	rl.InitWindow(c.SCREEN_WIDTH, c.SCREEN_HEIGHT, c.APP_NAME)
	center_window(c.SCREEN_WIDTH, c.SCREEN_HEIGHT)

	rl.SetTargetFPS(c.TARGET_FPS)

	app = App {
		state = .RUNNING,
	}

	game.init()
}

run :: proc() {
	for app.state == .RUNNING {
		update()
		draw()
	}
}

quit :: proc() {
	rl.CloseWindow()
}

@(private)
update :: proc() {
	if game.update() == game.Game_State.QUIT {
		app.state = .QUIT
	}
}

@(private)
draw :: proc() {
	rl.BeginDrawing()

	game.draw()

	rl.EndDrawing()
}

@(private)
center_window :: proc(screen_width, screen_height: i32) {
	pos := rl.GetMonitorPosition(rl.GetCurrentMonitor())
	rl.SetWindowPosition(
		i32(pos.x) + rl.GetMonitorWidth(rl.GetCurrentMonitor()) / 2 - screen_width / 2,
		i32(pos.y) + rl.GetMonitorHeight(rl.GetCurrentMonitor()) / 2 - screen_height / 2,
	)
}
