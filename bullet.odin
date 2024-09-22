package main

import rl "vendor:raylib"

Bullet :: struct {
    pos: rl.Vector2,
    speed: f32,
    active: bool,
    bounds: rl.Rectangle,
}