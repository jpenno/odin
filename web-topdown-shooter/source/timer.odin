package game


Timer :: struct {
	duration: f32,
	time:     f32,
	state:    bool,
}

timer_init :: proc(duration: f32) -> Timer {
	return Timer{duration = duration}
}

timer_tick :: proc(t: ^Timer, dt: f32) -> bool {
	t.time -= dt
	if t.time <= 0 {
		t.time = t.duration
		return true
	}

	return false
}
