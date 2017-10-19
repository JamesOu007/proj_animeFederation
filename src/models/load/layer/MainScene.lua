
local MainScene = class("MainScene", gp.BaseNode)



function MainScene:ctor()
	MainScene.super.ctor(self)
	gp.AudioMgr:playMusic("pub/audio/music/a_chooselevel.mp3", true)
	local saveData = GMODEL(MOD.LOAD):getSaveData()
	local tmxData = Ref.TMXData
	-- if #saveData.selectHero == 0 then
		local docpath = cc.FileUtils:getInstance():getWritablePath().."hero.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath) == false then
			local str = gp.json.jsonTableToJString(saveData.selectHero)
			saveData.writeheroToDoc(str)
		else

			local str = saveData.readheroFromDoc()
			saveData.selectHero = gp.json.jsonTableFromString(str)
		end
	-- end

	if #saveData.guanqia == 0 then
		local docpath = cc.FileUtils:getInstance():getWritablePath().."guanka.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath) == false then
			local str = gp.json.jsonTableToJString(tmxData.guanqia)
			saveData.writeguankaToDoc(str)
			saveData.guanqia = tmxData.guanqia
		else
			local str = saveData.readguankaFromDoc()
			saveData.guanqia = gp.json.jsonTableFromString(str)
		end
	end

	if #saveData.haveZhuangbei == 0 then
		local docpath = cc.FileUtils:getInstance():getWritablePath().."zhuangbei.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath) == false then
			local str = gp.json.jsonTableToJString(saveData.haveZhuangbei)
			saveData.writezhuangbeiToDoc(str)
			-- saveData.guanqia = tmxData.guanqia
		else
			local str = saveData.readzhuangbeiFromDoc()
			saveData.haveZhuangbei = gp.json.jsonTableFromString(str)
		end
	end

	if #saveData.haveSuiPian == 0 then
		local docpath = cc.FileUtils:getInstance():getWritablePath().."suipian.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath) == false then
			local str = gp.json.jsonTableToJString(saveData.haveSuiPian)
			saveData.writesuipianToDoc(str)
			-- saveData.guanqia = tmxData.guanqia
		else
			local str = saveData.readsuipianFromDoc()
			saveData.haveSuiPian = gp.json.jsonTableFromString(str)
		end
	end
	self:_initUI()

end

function MainScene:_initUI( )
	self.isChoose = 1
--加载主界面
	local bg = gp.Sprite:create("zhucheng.png")
	self:addChild(bg)
	_VLP(bg)

	self.funcBtnList = {}

	self.moreClose = true
	local function _moreBtnCall( sender )
		self.moreClose = not self.moreClose
		if self.moreClose==true then
			sender:setKey("item_close_btn.png")
			for _,v in ipairs(self.funcBtnList) do
				v:setVisible(true)
			end
		else
			sender:setKey("item_open_btn.png")
			for _,v in ipairs(self.funcBtnList) do
				v:setVisible(false)
			end
		end
	end
	self.moreBtn = gp.Button:create("item_close_btn.png",_moreBtnCall)
	self:addChild(self.moreBtn)
	_VLP(self.moreBtn, self, vl.IN_BR, cc.p(-20,20))

	local function _battleBtnCall( sender )
		JOWinMgr:Instance():showWin(MCLASS(MOD.LOAD, "GameScene").new(), gd.LAYER_SCENE)
	end
	local battleBtn = gp.Button:create("zhengcheng.png",_battleBtnCall)
	self:addChild(battleBtn)
	_VLP(battleBtn, self, vl.IN_TL, cc.p(20,-20))

	local function _funcBtnCall( sender )
		local tag = sender:getTag()
		if tag==1 then
			JOWinMgr:Instance():showWin(MCLASS(MOD.LOAD, "FightingTouchView").new(), gd.LAYER_WIN)
		end
	end
	
	local btn1 = gp.Button:create("shangdian_icon.png",_funcBtnCall)
	self:addChild(btn1)
	btn1:setTag(1)
	_VLP(btn1, self.moreBtn, vl.OUT_L, cc.p(-30,0))
	table.insert(self.funcBtnList, btn1)

	local btn2 = gp.Button:create("zhuangbei_tubiao.png",_funcBtnCall)
	self:addChild(btn2)
	btn2:setTag(2)
	_VLP(btn2, btn1, vl.OUT_L, cc.p(-20,0))
	table.insert(self.funcBtnList, btn2)

	local btn3 = gp.Button:create("beibao_icon.png",_funcBtnCall)
	self:addChild(btn3)
	btn3:setTag(3)
	_VLP(btn3, btn2, vl.OUT_L, cc.p(-20,0))
	table.insert(self.funcBtnList, btn3)

	local btn4 = gp.Button:create("shengji_tubiao.png",_funcBtnCall)
	self:addChild(btn4)
	btn4:setTag(4)
	_VLP(btn4, btn3, vl.OUT_L, cc.p(-20,0))
	table.insert(self.funcBtnList, btn4)

	self.goldLabel = gp.Label:create("0", 20, gd.FCOLOR.c6)
	self.gemLabel = gp.Label:create("0", 20, gd.FCOLOR.c6)
	self.phyLabel = gp.Label:create("0", 20, gd.FCOLOR.c6)
	self.goldLabel:setAnchorPoint(cc.p(1,0.5))
	self.gemLabel:setAnchorPoint(cc.p(1,0.5))
	self.phyLabel:setAnchorPoint(cc.p(1,0.5))
	self:addChild(self.goldLabel)
	self:addChild(self.gemLabel)
	self:addChild(self.phyLabel)
	--self.label2:setAnchorPoint(cc.p(0,0.5))
	_VLP(self.goldLabel, battleBtn, vl.OUT_R, cc.p(100,20))
	_VLP(self.gemLabel, battleBtn, vl.OUT_R, cc.p(250,20))
	_VLP(self.phyLabel, battleBtn, vl.OUT_R, cc.p(400,20))

end

function MainScene:tick(  )
	self.count = self.count+1
	self.bar:setCurVal(self.count)
	if self.count == 2 then
        gp.AudioMgr.preloadMusic("pub/audio/music/a_chooselevel.mp3")
    elseif self.count == 4 then
        audio.preloadMusic("pub/audio/music/a_chuangjue.mp3")
    elseif self.count == 6 then
        audio.preloadMusic("pub/audio/music/a_gulangyumusic.mp3")
    elseif self.count == 8 then
        audio.preloadMusic("pub/audio/music/a_shamomusic.mp3")
    elseif self.count == 10 then
        audio.preloadMusic("pub/audio/music/a_yechangmusic.mp3")
        loadLuaFile("pub/ref/HeroData")
    elseif self.count == 12 then
        audio.preloadMusic("pub/audio/music/a_yueyemusic.mp3")
       	
        JOWinMgr:Instance():showWin(MCLASS(MOD.LOAD, "StartGameView").new(), gd.LAYER_SCENE)

        --[[
        if #SaveData.selectHero == 0 then
            local docpath = cc.FileUtils:getInstance():getWritablePath() .. "hero.txt"
            if cc.FileUtils:getInstance():isFileExist(docpath)==false then
                local scene = StartGame.new()
                cc.Director:getInstance():replaceScene(scene)
            else
                local scene = MainScene.new()
                local turn = cc.TransitionPageTurn:create(1, scene, false)
                cc.Director:getInstance():replaceScene(turn)
            end
        end
        --]]
        self.count = 0
        gp.TickMgr:unRegister(self)
    end
end

function MainScene:onEnter(  )
	--gp.TickMgr:register(self)
end

function MainScene:onExit(  )
	--gp.TickMgr:unRegister(self)
end
--[[
function MainScene:_initLayer(  )
	local layer = MCLASS(MOD.FIGHT, "FightBgBaseLayer").new()
	layer:setBgImg("back1_1.png", "back1_2.png")
	layer:setSpeed(100)
	self:setLayer(layer, 1)
	layer = MCLASS(MOD.FIGHT, "FightBgBaseLayer").new()
	layer:setBgImg("back2_1.png", "back2_2.png")
	layer:setSpeed(40)
	self:setLayer(layer, 2)
	layer = MCLASS(MOD.FIGHT, "FightBgBaseLayer").new()
	layer:setBgImg("back3_1.png", "back3_2.png")
	layer:setSpeed(60)
	layer:setIsUp(true)
	self:setLayer(layer, 3)

	GMODEL(MOD.FIGHT).bulletMgr:setBulletParent(self)
end

function MainScene:setSpeedWithLayer(speed, layerId)	
	local tmpLayer = self.layerMap[layerId]
	if tmpLayer then
		tmpLayer:setSpeed(speed)
	end	
end

function MainScene:setLayer(layer, layerId)
	local tmpLayer = self.layerMap[layerId]
	if tmpLayer then
		tmpLayer:removeFromParent()
	end
	if layer then
		self.layerMap[layerId] = layer
		self:addChild(layer, BACKGROUND_LAYER_TAG)
		_VLP(layer, self)
	end
end
--]]
return MainScene

