pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- asteroids
-- games by emre

-------------------------------------------------------------------------------
-- Global Variables
-------------------------------------------------------------------------------
cpu_difficulty = 1
-- I should define a difficulty progression algorithm...
debugmsg = ''
is_debugmode = false

-- Score
score = 0

timer_count = 0
timer_start = 0
timer_end = 0
global_state = 0

Entity = {}
Entity.__index = Entity

function Entity.create(px,py,vx,vy,ax,ay,rotation,
    spr,anim_seq,anim_framerate)
  local new_entity = {}
  setmetatable(new_entity, Entity)

  new_entity.px = px
  new_entity.py = py
  new_entity.vx = vx
  new_entity.vy = vy
  new_entity.ax = ax
  new_entity.ay = ay
  new_entity.rotation  = rotation
  
  new_entity.spr = spr
  new_entity.anim_seq = anim_seq
  new_entity.anim_seq_index = 1
  new_entity.anim_framerate = anim_framerate
  new_entity.anim_num_frames = count(anim_seq)
  new_entity.frames = 0

	return new_entity
end

function draw_ent(ent)
  ent.frames += 1
  
  if ent.anim_seq == nil then
    drawspr(ent.spr,ent.pos_x,ent.pos_y)
  else
    if ent.frames >= 30/ent.anim_framerate then
      ent.anim_seq_index += 1
      if ent.anim_seq_index > ent.anim_num_frames then
        ent.anim_seq_index = 1
      end
      ent.frames = 0
    end

    drawspr(ent.anim_seq[ent.anim_seq_index],ent.pos_x,ent.pos_y)
  end
end

function _init()
  -- define app states
  state_init_match, state_init_game, state_next_level, state_game_over, state_title_screen = 1, 2, 3, 4, 5

  -- define draw_funcs
  draw_funcs = {[state_init_game]=draw_nothing,
                [state_init_match]=draw_main_screen,
                [state_next_level]=draw_next_level,
                [state_game_over]=draw_game_over_screen,
                [state_title_screen]=draw_title_screen
              }

  -- define update_funcs
  update_funcs = {[state_init_game]=update_init_game,
                [state_init_match]=update_init_match,
                [state_next_level]=update_next_level,
                [state_select_position]=update_select_position,
                [state_title_screen]=update_title_screen
              }

  global_state = state_init_game
end

function _update()
  update_funcs[global_state]()

  timer_count += 1
end

function _draw()
  draw_funcs[global_state]()
end

function draw_nothing()
  i=1
end

function update_init_game()
  music(0)
  global_state = state_title_screen

  debugmsg = 'update_init_game()'
end