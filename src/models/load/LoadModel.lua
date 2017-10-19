
--[[
=================================
文件名：LoadModel.lua
作者：James Ou
=================================
]]
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/ctrl/SaveData" )
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/layer/LoadView" )
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/layer/StartGameView" )
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/layer/HeroView" )
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/layer/MainScene" )

gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/layer/FightingTouchView" )
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/entity/AFHero" )
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/entity/AFEnemy" )
gp.ModelMgr:modelSubLua( MOD.LOAD, "models/load/layer/GameScene" )



local LoadModel = LoadModel or class("LoadModel", gp.BaseModel)


function LoadModel:onInitData()
	self.saveData = MCLASS(MOD.LOAD, "SaveData").new()
	--local csb = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("pub/csb/MainScene.csb")
	local csb = cc.CSLoader:createNode("MainScene.csb")
	--local csb = ccs.GUIReader:getInstance():widgetFromJsonFile("pub/csb/MainScene.csb")
	if csb==nil then
		LOG_ERROR("","csb is nil")
	else
		JOWinMgr:Instance():showWin(csb, gd.LAYER_SCENE)
	end
end

function LoadModel:onInitEvent()
	
end


function LoadModel:onDelete( )
	--析构UI

	--析构MGR及其它对象
	
	--析构父类
	LoadModel.super.onDelete(self)
end

--数据相关----------------------------------------------------------------------------
function LoadModel:getSaveData(  )
	return self.saveData
end

--ui相关----------------------------------------------------------------------------
function LoadModel:showLoadLayer( )
	--JOWinMgr:Instance():showWin(MCLASS(MOD.LOAD, "LoadView").new(), gd.LAYER_SCENE)
end

--消息相关----------------------------------------------------------------------------

--[[
--成功错误码处理----------------------------------------------------------------------------
function LoadModel:handleErrorCode(errorData)

end

function LoadModel:handleSuccessCode(successData)

end
--]]

return LoadModel