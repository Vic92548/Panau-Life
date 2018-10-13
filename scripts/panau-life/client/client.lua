User = {}
User["vehicles"] = {}
HudLoaded = false

function UpdateUser(sentMessage)
    User = sentMessage
    UserLoaded = true
    HudLoaded = true
end

Network:Subscribe("UpdateUser", UpdateUser)