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

global_acc = 0 -- global accumulator
timer_start = 0
timer_end = 0
global_state = 0

Timer = {}
Timer.__index = Timer

function Timer.create(num_frames)
  local new_timer = {}
  setmetatable(new_timer, Timer)

  new_timer.num_frames = num_frames
  new_timer.timer_start = global_acc
  new_timer.timer_end = global_acc + num_frames
  new_timer.status = 'active'
  return new_timer
end

function is_timer_finished(timer)
  if timer.timer_end <= global_acc then
    return true
  else
    return false
  end
end

function timer_update(timer)
  i=1
end

-- State = {}
-- State.__index = State
-- num_states = 0

-- function State.create(draw_func, update_func)
--   num_states += 1
--   local new_state  = {}
--   setmetatable(new_state, State)

--   new_state.draw_func = draw_func
--   new_state.update_func = update_func
--   new_state.index = num_states

--   return new_state
-- end

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

function drawspr(_spr,_x,_y,_c)
  --palt(0,false)
  if _c !=  nil then
    pal(7,_c)
  end
  spr(_spr,_x,_y)
  pal()
end

function _init()
  -- define app states
  state_init_game, state_next_level, state_game_over, state_init_title_screen, state_title_screen = 1, 2, 3, 4, 5
  --state_init_match = State.create(draw_main_screen, update_init_match)

  -- define draw_funcs
  draw_funcs = {[state_init_game]=draw_nothing,
                [state_next_level]=draw_next_level,
                [state_game_over]=draw_game_over_screen,
                [state_title_screen]=draw_title_screen,
                [state_init_title_screen]=draw_nothing
              }

  -- define update_funcs
  update_funcs = {[state_init_game]=update_init_game,
                [state_next_level]=update_next_level,
                [state_game_over]=update_game_over,
                [state_title_screen]=update_title_screen,
                [state_init_title_screen]=update_init_title_screen
              }

  global_state = state_init_game
end

function _update()
  update_funcs[global_state]()

  global_acc += 1 -- global accumulator
end

function _draw()
  draw_funcs[global_state]()
end

function draw_nothing()
  i=1
end

function update_init_game()
  music(0)
  global_state = state_init_title_screen

  debugmsg = 'update_init_game()'
end

function draw_title_screen()
  -- clear the screen
  rectfill(0,0,128,128,3)

  if(is_timer_finished(timer_display_title_1)==true) then 
    print("It's a title screen...1!", 1, 1, 1) 
  end

  if(is_timer_finished(timer_display_title_2)==true) then 
    print("It's a title screen...2!", 1, 20, 1) 
  end

  if(is_timer_finished(timer_display_title_3)==true) then 
    print("It's a title screen...3!", 1, 40, 1) 
  end
end

function update_init_title_screen()
  display_title_1 =  false
  display_title_2 =  false
  display_title_3 =  false

  timer_display_title_1 = Timer.create(15)
  timer_display_title_2 = Timer.create(30)
  timer_display_title_3 = Timer.create(120)

  global_state = state_title_screen
end

function update_title_screen()
  i=1
end