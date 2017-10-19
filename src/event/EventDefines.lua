
local SOCKET_BEGIN = 10

local GAME_BEGIN = 200
local function EVENT_AUTO_ID( )
	GAME_BEGIN = GAME_BEGIN+1
	return GAME_BEGIN
end
--其它本地消息从必须500开始


local evids = {}
--SOCKET的本地事件消息
evids.SOCKET_CONNECT = SOCKET_BEGIN+1
evids.SOCKET_DISCONNECT = SOCKET_BEGIN+2
evids.SOCKET_CONNECTFAIL = SOCKET_BEGIN+3
evids.SOCKET_RECVOP = SOCKET_BEGIN+4
--DEBUG的本地事件消息
evids.DEBUG_RELOAD_LOG = EVENT_AUTO_ID()
--主界面消息
evids.LOAD_SEL_HERO = EVENT_AUTO_ID()
evids.LOAD_FIGHT_TOUCH_MYNEW = EVENT_AUTO_ID()




local function checkDuplicateError( )
	local t = {}
	for k,v in pairs(evids) do
		if t[v] == true then
			LOG_ERROR("EventDefines", "==========EVENTID DUPLICATE %d", v)
		end
		t[v] = true
	end	
end 

checkDuplicateError()

return evids