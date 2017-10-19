
local StartGameView = class("StartGameView", gp.BaseNode)

function StartGameView:ctor()
	StartGameView.super.ctor(self)

	self:_initUI()
	self:setCatchTouch(true)
end

function StartGameView:_initUI()
	self.bg = gp.Sprite:create("login_bg.png", false)
	self.bg:setScaleX(gd.VISIBLE_SIZE.width/self.bg:getContentSize().width)
	self.bg:setScaleY(gd.VISIBLE_SIZE.height/self.bg:getContentSize().height)
	self:addChild(self.bg)
	_VLP(self.bg)

	--艾丽
    self.skeletonNode1 = sp.SkeletonAnimation:create("pub/spine/xiaonvhai/skeleton.json", "pub/spine/xiaonvhai/skeleton.atlas",0.5) --Spine动画对象
    self.skeletonNode1:setAnimation(0,"idle",true)
    self.skeletonNode1:setTag(1001)
    self.skeletonNode1:setScaleX(-1)
    self:addChild(self.skeletonNode1)
    _VLP(self.skeletonNode1, self, vl.CENTER, cc.p(-150,30))
    

--技术草
    self.skeletonNode2 = sp.SkeletonAnimation:create("pub/spine/jishucao/skeleton.json", "pub/spine/jishucao/skeleton.atlas",0.5)
    self.skeletonNode2:setAnimation(0,"idle",true)
    self.skeletonNode2:setTag(1002)
    self:addChild(self.skeletonNode2)
    _VLP(self.skeletonNode2, self, vl.CENTER, cc.p(150,0))
    

--路飞    
    self.skeletonNode3 = sp.SkeletonAnimation:create("pub/spine/lufei/skeleton.json", "pub/spine/lufei/skeleton.atlas",0.5)
    self.skeletonNode3:setAnimation(0,"idle",true)
    self.skeletonNode3:setTag(1003)
    self:addChild(self.skeletonNode3)
    _VLP(self.skeletonNode3, self, vl.CENTER, cc.p(-220,-180))
    self.skeletonNode3:setScaleX(-1)


--浩克
    self.skeletonNode4 = sp.SkeletonAnimation:create("pub/spine/lvjuren/skeleton.json", "pub/spine/lvjuren/skeleton.atlas",0.5)
    self.skeletonNode4:setAnimation(0,"idle",true)
    self.skeletonNode4:setTag(1004)
    self:addChild(self.skeletonNode4)
    _VLP(self.skeletonNode4, self, vl.CENTER, cc.p(200,-200))

end

function StartGameView:onEnter()
	StartGameView.super.onEnter(self)
	gp.AudioMgr:playMusic("pub/audio/music/a_chuangjue.mp3")

	local function _eventHandle(eveId, dataCoder)
		LOG_INFO("DemoMessage1", "eveId = %d ", eveId)
		if dataCoder then
			local heroIdx = dataCoder:getInt()
			local heroNode = nil
			if heroIdx==1 then
				self.skeletonNode1:setVisible(true)
				self.skeletonNode2:setVisible(false)
				self.skeletonNode3:setVisible(false)
				self.skeletonNode4:setVisible(false)
				heroNode = self.skeletonNode1
				heroNode:setAnimation(0,"atk1",false)
			elseif heroIdx==2 then
				self.skeletonNode1:setVisible(false)
				self.skeletonNode2:setVisible(true)
				self.skeletonNode3:setVisible(false)
				self.skeletonNode4:setVisible(false)
				heroNode = self.skeletonNode2
				heroNode:setAnimation(0,"atk2",false)
			elseif heroIdx==3 then
				self.skeletonNode1:setVisible(false)
				self.skeletonNode2:setVisible(false)
				self.skeletonNode3:setVisible(true)
				self.skeletonNode4:setVisible(false)
				heroNode = self.skeletonNode3
				heroNode:setAnimation(0,"atk2",false)
			elseif heroIdx==4 then
				self.skeletonNode1:setVisible(false)
				self.skeletonNode2:setVisible(false)
				self.skeletonNode3:setVisible(false)
				self.skeletonNode4:setVisible(true)
				heroNode = self.skeletonNode4
				heroNode:setAnimation(0,"atk3",false)
			else
				return
			end
			transition.scaleTo(self.bg,{time = 0.2,scale = 1.2})
            transition.moveTo(self.bg, {time = 0.2,y =200,x =700})
            transition.scaleTo(heroNode, {time = 0.2,scale = 1.8})  
            transition.moveTo(heroNode, {time = 0.2,y =200,x =550})
		end
	end
	gp.MessageMgr:registerEvent(self.sn, gei.LOAD_SEL_HERO, _eventHandle)
end

function StartGameView:onExit()
	StartGameView.super.onExit(self)
	gp.MessageMgr:unRegisterEvent(self.sn)
end

function StartGameView:onTouchEnded(touch, event)
	local p=touch:getLocation()

	JOWinMgr:Instance():showWin(MCLASS(MOD.LOAD, "HeroView").new(), gd.LAYER_WIN)
end


return StartGameView

