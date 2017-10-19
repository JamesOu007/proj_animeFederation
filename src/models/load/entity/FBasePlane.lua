
local FBasePlane = class("FBasePlane", gp.BaseNode)

function FBasePlane:ctor()
	FBasePlane.super.ctor(self)	
	self:setAnchorPoint(cc.p(0.5,0.5))
	self.player = gp.Sprite:create()
	
	self:addChild(self.player)
	_VLP(self.player)
	--活动区域
	self.zoneRect = gd.VISIBLE_RECT
	
	--飞机大小
	self.playerSize = cc.size(0,0)
	
	self.totalHp = 0
	self.curHp = 0
	self.att = 0
	self.def = 0

	--
	self.firstBulletDelay = 0
	self.bulletInterval = 0.3
end
--设置飞机图形，以为可能换为序列帧
function FBasePlane:setImg( img )
	self.player:setKey(img, false)
	self.playerSize = self.player:getContentSize()
	self:setContentSize(self.playerSize)
end
--设置活动区域
function FBasePlane:setZoneOfAction( rect )
	self.zoneRect = rect
end
--设置子弹发射器
function FBasePlane:setBulletInterval( interval, delay )
	self.bulletInterval = interval
	self.firstBulletDelay = delay
end
--开始射击
function FBasePlane:startFire(  )
	local function _loopCall(  )
		self:onFire()
	end
	self.loopId = gp.TickMgr:loopCall(self.firstBulletDelay, self.bulletInterval, _loopCall)
end
--停止射击
function FBasePlane:stopFire(  )
	gp.TickMgr:stopLoopCall(self.loopId)
end

function FBasePlane:onExit(  )
	self:stopFire()
	FBasePlane.super.onExit(self)
end

--over write for sub class
function FBasePlane:onFire(  )
	
end
--被击中
function FBasePlane:onHit( hurtVal )
	
end

return FBasePlane

