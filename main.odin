package main

import rl "vendor:raylib"
import fmt "core:fmt"
import os "core:os"

score: i32

scale_mul: i32 = 45
fly_scale_mul: i32 = 6

MAX_BULLETS :: 50
MAX_FLYS :: 1

player: Player

main :: proc() {
    rl.InitWindow(1280, 720, "Flys Are Attacking The ISS")
    defer rl.CloseWindow()
    rl.InitAudioDevice()
    defer rl.CloseAudioDevice()

    rl.SetTargetFPS(60)

    //INIT
    bg: rl.Texture2D = rl.LoadTexture("assets/space_wallpaper.png")
    iss: rl.Texture2D = rl.LoadTexture("assets/iss.png")
    iss.width *= scale_mul
    iss.height *= scale_mul

    bg_music := rl.LoadMusicStream("assets/bg.mp3")
    rl.PlayMusicStream(bg_music)

    pew_sound := rl.LoadSound("assets/pew.mp3")

    init_player(&player)

    bullets: [MAX_BULLETS]Bullet
    for i in 0..<MAX_BULLETS {
        bullets[i].speed = 500
        bullets[i].active = false
    }

    flys: [MAX_FLYS]Fly
    for i in 0..<MAX_FLYS {
        flys[i].tex = rl.LoadTexture("assets/fly.png")
        flys[i].tex.width *= fly_scale_mul
        flys[i].tex.height *= fly_scale_mul
        flys[i].speed = 200
        flys[i].active = false
    }

    for !rl.WindowShouldClose() {
        //UPDATE
        rl.UpdateMusicStream(bg_music)

        update_player(&player)

        //update bullets
        if rl.IsKeyPressed(.SPACE) {
            rl.PlaySound(pew_sound)

            for i in 0..<MAX_BULLETS {
                if !bullets[i].active {
                    bullets[i].pos.x = player.pos.x + 100
                    bullets[i].pos.y = player.pos.y + 40
                    bullets[i].active = true
                    break
                }
            }
        }
        for i in 0..<MAX_BULLETS {
            if bullets[i].active {
                bullets[i].bounds = {
                    bullets[i].pos.x,
                    bullets[i].pos.y,
                    5,
                    5,
                }

                bullets[i].pos.x += bullets[i].speed * rl.GetFrameTime()

                if bullets[i].pos.x > f32(rl.GetScreenWidth()) {
                    bullets[i].active = false
                }
            }
        }

        //update flys
        for i in 0..<MAX_FLYS {
            if !flys[i].active {
                flys[i].pos.x = f32(rl.GetScreenWidth())
                flys[i].pos.y = f32(rl.GetRandomValue(0, rl.GetScreenHeight() - 96))
                flys[i].active = true
                break
            }
        }
        for i in 0..<MAX_FLYS {
            if flys[i].active {
                flys[i].bounds = {
                    flys[i].pos.x,
                    flys[i].pos.y,
                    f32(flys[i].tex.width),
                    f32(flys[i].tex.height),
                }

                flys[i].pos.x -= flys[i].speed * rl.GetFrameTime()

                if flys[i].pos.x <= 270 {
                    os.exit(0)
                }
            }
        }

        for i in 0..<MAX_BULLETS {
            for i in 0..<MAX_FLYS {
                if rl.CheckCollisionRecs(bullets[i].bounds, flys[i].bounds) {
                    score += 1
                    bullets[i].active = false
                    flys[i].active = false
                }
            }
        }

        rl.BeginDrawing()
            //DRAW
            rl.DrawTexture(bg, 0, 0, rl.WHITE)

            rl.DrawTexture(iss, 0, 0, rl.WHITE)

            rl.DrawText(rl.TextFormat("Score: %i", score), rl.GetScreenWidth() / 2, 0, 30, rl.WHITE)

            draw_player(&player)

            for i in 0..<MAX_BULLETS {
                if bullets[i].active {
                    rl.DrawRectangleV(bullets[i].pos, 5, rl.YELLOW)

                    //rl.DrawRectangleLines(i32(bullets[i].bounds.x), i32(bullets[i].bounds.y), i32(bullets[i].bounds.width), i32(bullets[i].bounds.height), rl.RED)
                }
            }

            for i in 0..<MAX_FLYS {
                if flys[i].active {
                    rl.DrawTextureV(flys[i].tex, flys[i].pos, rl.WHITE)

                    //rl.DrawRectangleLines(i32(flys[i].bounds.x), i32(flys[i].bounds.y), i32(flys[i].bounds.width), i32(flys[i].bounds.height), rl.RED)
                }
            }
        rl.EndDrawing()
    }
}