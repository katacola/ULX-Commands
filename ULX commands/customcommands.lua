if (SERVER) then

	util.AddNetworkString("target_ply")
    util.AddNetworkString("friendlist")

    net.Receive( "friendlist", function(len, ply)
            local friends = net.ReadTable()
            local friendstring = table.concat(  friends, ", " )
            ulx.fancyLogAdmin( nil, true,  "#T is friends with: #s ", ply, friendstring )
    end)
end
if CLIENT then
    net.Receive("friendlist", function()
                local friends = {}
                for k, v in pairs(player.GetAll()) do
                        if v:GetFriendStatus() == "friend" then
                            table.insert( friends, v:Nick() )
                            end
                end
                net.Start("friendlist")
                   net.WriteTable(friends)
                net.SendToServer()
    end)
end


function ulx.listfriends(calling_ply, target_ply)

        net.Start("friendlist")
        net.Send(target_ply)
end
local listfriends = ulx.command("Essentials", "ulx listfriends", ulx.listfriends, "!friends",true)
listfriends:addParam{ type=ULib.cmds.PlayerArg }
listfriends:defaultAccess( ULib.ACCESS_ADMIN )
listfriends:help( "Check for friends playing on the server." )

function ulx.watch(calling_ply, target_ply,reason)
	target_ply:SetPData("Watched","true")
	target_ply:SetPData("WatchReason",reason)
	ulx.fancyLogAdmin( calling_ply, true, "#A marked #T as watched: "..reason.. "" , target_ply )
end
local watch = ulx.command("Essentials", "ulx watch", ulx.watch, "!watch",true)
watch:addParam{ type=ULib.cmds.PlayerArg }
watch:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.takeRestOfLine }
watch:defaultAccess( ULib.ACCESS_ADMIN )
watch:help( "Puts a player on watch list." )

function ulx.unwatch(calling_ply, target_ply)
	target_ply:SetPData("Watched","false")
	target_ply:RemovePData("WatchReason")
	ulx.fancyLogAdmin( calling_ply, true, "#A removed #T from watch list", target_ply )
end
local unwatch = ulx.command("Essentials", "ulx unwatch", ulx.unwatch, "!unwatch",true)
unwatch:addParam{ type=ULib.cmds.PlayerArg }
unwatch:defaultAccess( ULib.ACCESS_ADMIN )
unwatch:help( "Removes a player from watch list." )

function userAuthed( ply, stid, unid )
	if ply:GetPData("Watched") == "true" then
		ulx.fancyLogAdmin(nil, true, "#T ("..stid.. ") is on the watchlist: "..ply:GetPData("WatchReason").. "",ply)
	end
end
hook.Add( "PlayerAuthed", "watchlisthook", userAuthed )

function ulx.watchlist(calling_ply)
	watchlist = {}
	for k, v in pairs(player.GetAll()) do
		if v:GetPData("Watched") == "true" then
			table.insert( watchlist, v:Nick())
			table.insert(watchlist, v:GetPData("WatchReason"))
		end
	end
	local watchstring = table.concat(  watchlist, ", " )
	ulx.fancyLogAdmin( nil, true,  "Watchlist: #s ",watchstring )
end
local watchlist = ulx.command("Essentials", "ulx watchlist", ulx.watchlist, "!watchlist",true)
watchlist:defaultAccess( ULib.ACCESS_ADMIN )
watchlist:help( "Prints watch list." )

--[[
function leavemessage( ply )
	 ULib.tsayColor( nil, false, Color(0,200,0), ply:Nick(),Color(151,211,255)," has disconnected. ("..ply:SteamID().. ")")
end
hook.Add( "PlayerDisconnected", "leave message", leavemessage )
]]--