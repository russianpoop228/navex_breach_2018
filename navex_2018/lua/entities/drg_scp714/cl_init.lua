--[[
lua/entities/drg_scp714/cl_init.lua
--]]
include("shared.lua")

function ENT:Draw()
  self:DrawModel()
end

net.Receive("Wearing714", function(len, ply)
  chat.AddText("Вы носите SCP-714.")
end)

net.Receive("714RunJumpFatigue", function(len, ply)
  chat.AddText("Вы чувствуете себя слишком усталым, чтобы бегать или прыгать.")
end)

net.Receive("714RunFatigue", function(len, ply)
  chat.AddText("Вы чувствуете себя слишком усталым, чтобы бежать.")
end)

net.Receive("714JumpFatigue", function(len, ply)
  chat.AddText("Вы чувствуете себя слишком усталым, чтобы прыгать.")
end)

net.Receive("AlreadyWearing714", function(len, ply)
  chat.AddText("Вы не можете носить другой SCP-714.")
end)

net.Receive("Dropped714", function(len, ply)
  if net.ReadBool() then
    chat.AddText("Вы сняли SCP-714.")
  end
end)

net.Receive("714FatigueKill", function(len, ply)
  chat.AddText("Кольцо сделало тебя неспособным встать. Ты хранил его слишком долго.")
end)


