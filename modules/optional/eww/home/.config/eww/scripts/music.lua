#!/usr/bin/env luajit

local lib = require("scripts.lib")

local data = {}

function data:update()
  local status = lib.pipe("mpc", 3)

  self.playing = (status[2] or ""):find("%[playing%]") ~= nil
  self.volume = status[#status]:match("volume:%s*(%d+)")
  self.repeat_ = status[#status]:match("repeat:%s*(%a+)") == "on"
  self.random = status[#status]:match("random:%s*(%a+)") == "on"
  self.single = status[#status]:match("single:%s*(%a+)") == "on"
  self.consume = status[#status]:match("consume:%s*(%a+)") == "on"
end

function data:print()
  io.write(
    string.format(
      '{"playing":%s,"volume":%s,"repeat":%s,"random":%s,"single":%s,"consume":%s}\n',
      self.playing,
      self.volume,
      self.repeat_,
      self.random,
      self.single,
      self.consume
    )
  )
end

while true do
  data:update()
  data:print()

  -- Wait for the following events:
  -----------------------
  -- Event    | Triggers
  -----------------------
  -- update   | update
  -- playlist | add, clear
  -- player   | play, pause, stop, next, prev
  -- mixer    | volume
  -- options  | repeat, random, single, consume
  os.execute("mpc idle update playlist player mixer options >/dev/null")
end
