
local AFHero = class("AFHero", gp.BaseNode)

function AFHero:ctor()
	AFHero.super.ctor(self)	
	self:setAnchorPoint(cc.p(0.5,0.5))
	self.hpbj = gp.Sprite:create("hp.jpg")
	self.hpbj:setPosition(40,300)
	self.hpbj:setScale(1.5)
	self:addChild(self.hpbj)
	
	self.xueTiao = ccui.LoadingBar:create("pub/image/4444/img/xuetiao-lv.png")
	self.xueTiao:setDirection(2)
	self.xueTiao:setPercent(100);
	self.xueTiao:setPosition(60,308);
	self.xueTiao:setScale(1.5)
    self:addChild(self.xueTiao);

    self.jinengLQ1 = 3
    self.jinengLQ2 = 5
    self.jinengLQ3 = 10

	self.buffzhuangtai = 1     			--buff 状态
	self.xueliang = 100       			--血量
	self.beifenxueliang = self.xueliang --备份血量
	self.gongjili = 0          			--攻击力
	self.fangyuli = 0         			--防御力  
	self.shanbi = 0 					--闪避   百分比*随机数<80  被攻击到

	self.isDie = false
	
	self.beigongji = false
	self.gongjiChengGong = false
	-- self.beijinengYiShangHai
	-- self.is
	-- SkeletonRenderer
	local saveData = GMODEL(MOD.LOAD):getSaveData()
	local s = Ref.HeroData.hero[1]
	for i=1,#Ref.HeroData.hero do
		if saveData.selectHero[1].id == Ref.HeroData.hero[i].id then
		 	--s = Ref.HeroData.hero[i]
		 	break
		end 
	end
	LOG_WARN("", "model %s", tostring(s.model))

	self.yixiong = sp.SkeletonAnimation:create("pub/spine/".. s.model .."/skeleton.json","pub/spine/".. s.model .."/skeleton.atlas",1)
	--self.yixiong.debugBones = true
	self.jineng = sp.SkeletonAnimation:create("pub/spine/".. s.model .."/skeleton_effect.json","pub/spine/".. s.model .."/skeleton_effect.atlas",1)
	self:addChild(self.yixiong)
	self:addChild(self.jineng)

	self.sk = sp.SkeletonAnimation:create("pub/spine/effects/huangseguanghuan/huangseguanghuan.json","pub/spine/effects/huangseguanghuan/huangseguanghuan.atlas",1)
    self.sk:setAnimation(0,"animation",true)
    self:addChild(self.sk)

	self.isGongJiCiShu = 1
	self.DengDaiGongJiJieSHu = false
	self.isPutSkills = false
 	self:addStateMachine()

 	self.yixiong:registerSpineEventHandler(function (event)
    	-- print(string.format("[spine] %d end:", event.trackIndex))
    	-- dump(event)
    	if event.animation == "skill1" then
    		print("1")
    		self:doEvent("normal")
    		self.isPutSkills = false
    		-- self.jineng:setAnimation(0,"skill1",false)
		elseif event.animation == "skill2" then
			--todo
			self:doEvent("normal")
			self.isPutSkills = false
			-- self.jineng:setAnimation(0,"skill2",false)
		elseif event.animation == "skill3" then
			--todo
			self:doEvent("normal")
			self.isPutSkills = false
		elseif event.animation == "atk1" then
			print("攻击一")
			if self.isGongJiCiShu == 1 then
				self:doEvent("normal")
				self.isPutSkills = false
				self.DengDaiGongJiJieSHu = false
				self.gongjiChengGong = false
				-- scheduler.unscheduleGlobal(self.scheduler)
			else
				print("攻击二")
				-- scheduler.unscheduleGlobal(self.scheduler)
				self:doEvent("attack2")
				self.gongjiChengGong = false
			end
			
		elseif event.animation == "atk2" then
			print("攻击二xxzz")
			if self.isGongJiCiShu == 2 then
				self:doEvent("normal")
				self.isPutSkills = false
				self.DengDaiGongJiJieSHu = false
				self.gongjiChengGong = false
				-- scheduler.unscheduleGlobal(self.scheduler)
			else
				-- scheduler.unscheduleGlobal(self.scheduler)
				self:doEvent("attack3")
				self.gongjiChengGong = false
			end
			-- scheduler.unscheduleGlobal(self.scheduler)
		elseif event.animation == "atk3" then
			self:doEvent("normal")
			self.isPutSkills = false
			self.isGongJiCiShu = 1
			self.DengDaiGongJiJieSHu = false
			self.gongjiChengGong = false
			-- scheduler.unscheduleGlobal(self.scheduler)
		elseif event.animation == "floorhurt" then
			self.beigongji = false
			self:doEvent("normal")
			self.isPutSkills = false
			self.gongjiChengGong = false
			self.DengDaiGongJiJieSHu = false
			self.isGongJiCiShu = 1
    	end
    	-- scheduler.unscheduleGlobal(self.scheduler)
   	end, sp.EventType.ANIMATION_COMPLETE)

end

function AFHero:setPutSkills(a)
	self.isPutSkills = a
end

function AFHero:getPutSkills()
	return self.isPutSkills
end

function AFHero:doEvent(event)
  --if self.fsm:canDoEvent(event) then
	    self.fsm:process_event(event)
  --end
end

function AFHero:addStateMachine(  )
	local function _onenteridle()
		self.yixiong:setAnimation(0,"idle",true)
	end
	local function _onenterwalk() 
 		self.yixiong:setAnimation(0,"walk",true)  
    end 
	local function _onenterrun()  
    	self.yixiong:setAnimation(0,"run",true)
    end
    local function _onenteratk1()  
    	self.yixiong:setAnimation(0,"atk1",false) 
    	self.jineng:setAnimation(0,"atk1",false)
    	self.isPutSkills = true
    	-- self.scheduler = scheduler.scheduleGlobal(handler(self, self.PengZhuangJianCe),0.1)
    end
    local function _onenteratk2()
    	self.yixiong:setAnimation(0,"atk2",false)
    	self.jineng:setAnimation(0,"atk2",false)
    	self.isPutSkills = true
    	-- self.scheduler = scheduler.scheduleGlobal(handler(self, self.PengZhuangJianCe),0.1)
    end
    local function _onenteratk3()
    	self.yixiong:setAnimation(0,"atk3",false)
    	self.jineng:setAnimation(0,"atk3",false)
    	self.isPutSkills = true
    	-- self.scheduler = scheduler.scheduleGlobal(handler(self, self.PengZhuangJianCe),0.1)
    end
    local function _onenterskill1()
    	--先等待一会
    	local a1 = cc.DelayTime:create(0.2)
    	local a2 = cc.MoveBy:create(0.5,cc.p(480*(-self.yixiong:getScaleX()),0))
    	-- local s = transition.sequence(a1,a2)
    	local s = cc.Sequence:create(a1,a2,nil)
    	self:runAction(s)
    	self.yixiong:setAnimation(0,"skill1",false)
    	self.jineng:setAnimation(0,"skill1",false)
    	self.isPutSkills = true
    end
    local function _onenterskill2()
    	self.yixiong:setAnimation(0,"skill2",false)
    	self.jineng:setAnimation(0,"skill2",false)
    	self.isPutSkills = true
    end
    local function _onenterskill3()
    	self.yixiong:setAnimation(0,"skill3",false)
    	self.jineng:setAnimation(0,"skill3",false)
    	self.isPutSkills = true
    end
    local function _onenterfloorhurt()
    	self.yixiong:setAnimation(0,"floorhurt",false)
    end
    local function _onenterdie ()
    	self.yixiong:clearTracks()
        self.jineng:clearTracks()
    	self.yixiong:setAnimation(0,"die",false)
    	self.jineng:setAnimation(0,"die",false)
    end
    local function _onenterwin()
    	self.yixiong:setAnimation(0,"win",false)
    	self.jineng:setAnimation(0,"win",false)
    end
	self.fsm=gp.stateMachine.new("idle")
	self.fsm:add_transition({ "walk", "run", "atk1", "atk2", "atk3","skill1","skill2","skill3","floorhurt","win"}, "normal", "idle", _onenteridle)
	self.fsm:add_transition({ "idle", "run"}, "move1", "walk", _onenterwalk)
	self.fsm:add_transition({ "idle", "walk"}, "move2", "run", _onenterrun)
	self.fsm:add_transition({ "idle", "walk", "run"}, "attack1", "atk1", _onenteratk1)
	self.fsm:add_transition({ "idle", "walk", "run", "atk1"}, "attack2", "atk2", _onenteratk2)
	self.fsm:add_transition({ "idle", "walk", "run", "atk2"}, "attack3", "atk3", _onenteratk3)
	self.fsm:add_transition({ "idle", "walk", "run"}, "skills1", "skill1", _onenterskill1)
	self.fsm:add_transition({ "idle", "walk", "run"}, "skills2", "skill2", _onenterskill2)
	self.fsm:add_transition({ "idle", "walk", "run"}, "skills3", "skill3", _onenterskill3)
	self.fsm:add_transition({ "idle", "walk", "run"}, "injured", "floorhurt", _onenterfloorhurt)
	self.fsm:add_transition({ "idle", "walk", "run", "atk1", "atk2", "atk3", "skill1","skill2","skill3"}, "death", "die", _onenterdie)
	self.fsm:add_transition({ "idle", "walk", "run", "atk1", "atk2"}, "victory", "win", _onenterwin)
	--[[
	--cc.GameObject.extend(self.fsm):addComponent("components.behavior.StateMachine"):exportMethods()
	self.fsm:setupState({
		initial="idle",
		events={
			{name ="normal", from={ "walk", "run", "atk1", "atk2", "atk3","skill1","skill2","skill3","floorhurt","win"}, to ="idle"},
			{name ="move1",   from={"idle", "run" }, to ="walk"},
			{name ="move2",   from={"idle", "walk"}, to ="run"},
			{name ="attack1", from={"idle", "walk", "run" }, to ="atk1"},  
	    	{name ="attack2", from={"idle", "walk", "run", "atk1"}, to ="atk2"},
			{name ="attack3", from={"idle", "walk", "run", "atk2"}, to ="atk3"},
			{name ="skills1", from={"idle", "walk", "run"}, to ="skill1"},
			{name ="skills2", from={"idle", "walk", "run"}, to ="skill2"},
			{name ="skills3", from={"idle", "walk", "run"}, to ="skill3"},
			{name ="injured", from={"idle", "walk", "run"}, to ="floorhurt"},--被攻击
			{name ="death", from={"idle", "walk", "run", "atk1", "atk2", "atk3", "skill1","skill2","skill3"}, to ="die"},
			{name ="victory", from={"idle", "walk", "run", "atk1", "atk2"}, to ="win"},
		},
	    callbacks={
	    	onenteridle=function ()
	    		self.yixiong:setAnimation(0,"idle",true)
			end,
	   		onenterwalk = function () 
	     		self.yixiong:setAnimation(0,"walk",true)  
	        end,  
	   		onenterrun = function ()  
	        	self.yixiong:setAnimation(0,"run",true)
	        end,
	        onenteratk1 = function ()  
	        	self.yixiong:setAnimation(0,"atk1",false) 
	        	self.jineng:setAnimation(0,"atk1",false)
	        	self.isPutSkills = true
	        	-- self.scheduler = scheduler.scheduleGlobal(handler(self, self.PengZhuangJianCe),0.1)
	        end,
	        onenteratk2 = function ()
	        	self.yixiong:setAnimation(0,"atk2",false)
	        	self.jineng:setAnimation(0,"atk2",false)
	        	self.isPutSkills = true
	        	-- self.scheduler = scheduler.scheduleGlobal(handler(self, self.PengZhuangJianCe),0.1)
	        end,
	        onenteratk3 = function ()
	        	self.yixiong:setAnimation(0,"atk3",false)
	        	self.jineng:setAnimation(0,"atk3",false)
	        	self.isPutSkills = true
	        	-- self.scheduler = scheduler.scheduleGlobal(handler(self, self.PengZhuangJianCe),0.1)
	        end,
	        onenterskill1 = function ()
	        	--先等待一会
	        	local a1 = cc.DelayTime:create(0.2)
	        	local a2 = cc.MoveBy:create(0.5,cc.p(480*(-self.yixiong:getScaleX()),0))
	        	-- local s = transition.sequence(a1,a2)
	        	local s = cc.Sequence:create(a1,a2,nil)
	        	self:runAction(s)
	        	self.yixiong:setAnimation(0,"skill1",false)
	        	self.jineng:setAnimation(0,"skill1",false)
	        	self.isPutSkills = true
	        end,
	        onenterskill2 = function ()
	        	self.yixiong:setAnimation(0,"skill2",false)
	        	self.jineng:setAnimation(0,"skill2",false)
	        	self.isPutSkills = true
	        end,
	        onenterskill3 = function ()
	        	self.yixiong:setAnimation(0,"skill3",false)
	        	self.jineng:setAnimation(0,"skill3",false)
	        	self.isPutSkills = true
	        end,
	        onenterfloorhurt = function ()
	        	self.yixiong:setAnimation(0,"floorhurt",false)

	        end,
	        onenterdie = function ()
	        	self.yixiong:clearTracks()
		        self.jineng:clearTracks()
	        	self.yixiong:setAnimation(0,"die",false)
	        	self.jineng:setAnimation(0,"die",false)
	        end,
	        onenterwin = function ()
	        	self.yixiong:setAnimation(0,"win",false)
	        	self.jineng:setAnimation(0,"win",false)
	        end,
		}
	})
--]]
end

function AFHero:setScaleX(sc)
	self.yixiong:setScaleX(sc)
	self.jineng:setScaleX(sc)
	self.sk:setScaleX(sc)
end

function AFHero:setXueLiang()
	 self.xueTiao:setPercent(self.xueliang/self.beifenxueliang*100)
end


function AFHero:onEnter(  )
	AFHero.super.onEnter(self)
	
end

function AFHero:onExit(  )
	
	AFHero.super.onExit(self)
end


return AFHero

