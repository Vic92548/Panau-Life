function PlayerGetAcces(args)
	print(args.player:GetName().." has been authenticated by Steam")

  local data = PanauLife.Database:query([[
    SELECT  user_steamid
    FROM    whitelisted
    WHERE   user_steamid = :steamid
    LIMIT   1
  ]], {
    [":steamid"] = self.player:GetSteamId().string
  })

  if not data then
    self.player:Kick("You are not whitelisted to this server.")
  end

end

Events:Subscribe("PlayerAuthenticate", PlayerGetAcces)

function ServerFunction(args)
	-- Call the network event "Test" for this player. The argument is a string.
	Network:Send(args.player, "Test", "Hello, client!")
end
Events:Subscribe("ClientModuleLoad", ServerFunction)
