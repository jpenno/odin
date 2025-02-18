package app

import rl "vendor:raylib"

Init :: proc(screen_width, screen_height: i32) {
	rl.InitWindow(screen_width, screen_height, "Flappy bird")
	center_window(screen_width, screen_height)
}

Run :: proc() {
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.GRAY)

		rl.EndDrawing()
	}
}

Quit :: proc() {
	rl.CloseWindow()
}

center_window :: proc(screen_width, screen_height: i32) {
	pos := rl.GetMonitorPosition(rl.GetCurrentMonitor())
	rl.SetWindowPosition(
		i32(pos.x) + rl.GetMonitorWidth(rl.GetCurrentMonitor()) / 2 - screen_width / 2,
		i32(pos.y) + rl.GetMonitorHeight(rl.GetCurrentMonitor()) / 2 - screen_height / 2,
	)
}
