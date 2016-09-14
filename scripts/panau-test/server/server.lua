function ServerFunction(args)
	-- Call the network event "Test" for this player. The argument is a string.
	Network:Send(args.player, "Test", "Hello, client!")
end
Events:Subscribe("ClientModuleLoad", ServerFunction)
