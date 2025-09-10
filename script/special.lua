--[[
PreloadUds这个函数会在“所有卡片加载之前”加载，可用于载入特殊规则，例如：
function aux.PreloadUds()
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_)
	e3:SetTargetRange(1,1)
	Duel.RegisterEffect(e3,0)
end
在这里加载一些全局有效的效果
GlobalEffect同样需要RegisterEffect来注册激活
--]]
function Auxiliary.PreloadUds()
	function require(str)
		--dofile(str..".lua")
		local len = string.len(str)
		local result=''
		for i=len,1,-1 do
			local temp=""
			temp=string.sub(str,i,i)
			if temp=="/" then
				result=result..".lua"
				Duel.LoadScript(result)
				return
			end
			result=temp..result
		end
		
	end
end
--这张卡在手卡·场上存在的场合才能发动。用包含这张卡的自己的手卡·场上的怪兽为素材作同调召唤。
--尝试降低运算需求，为炽天武装开发。建议同类效果也调用此函数。
--警告：禁止IGNITION以外种类效果使用
--调用方法：local e2=aux.GrandsCychroTargetCheckEffect(c)
function Auxiliary.GrandsCychroTargetCheckEffect(c)
	if not Auxiliary.GrandsCychroTargetCheckFilterGroup then 
		--存储同类卡片
		Auxiliary.GrandsCychroTargetCheckRgisterGroup=Group.CreateGroup()
		Auxiliary.GrandsCychroTargetCheckRgisterGroup:KeepAlive()
		--筛选可发动该效果的卡片
		Auxiliary.GrandsCychroTargetCheckFilterGroup=Group.CreateGroup()
		Auxiliary.GrandsCychroTargetCheckFilterGroup:KeepAlive()
		--统一检测
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetLabelObject(Auxiliary.GrandsCychroTargetCheckFilterGroup)
		ge1:SetOperation(Auxiliary.GrandsCychroTargetCheckEffectOperation)
		Duel.RegisterEffect(ge1,0)
	end 
	Auxiliary.GrandsCychroTargetCheckRgisterGroup:AddCard(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetLabelObject(Auxiliary.GrandsCychroTargetCheckFilterGroup)
	e1:SetTarget(Auxiliary.GrandsCychroTargetCheckTarget)
	e1:SetOperation(Auxiliary.GrandsCychroTargetCheckOperation)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.GrandsCychroTargetCheckEffectFilter1(c,tp)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsControler(tp)
end 
function Auxiliary.GrandsCychroTargetCheckEffectOperation(e)
	if Duel.GetCurrentChain()>0 then return end 
	local fg=e:GetLabelObject()
	fg:Clear()
	for i=0,1 do
		local mg=Duel.GetMatchingGroup(Auxiliary.GrandsCychroTargetCheckEffectFilter1,i,LOCATION_HAND+LOCATION_MZONE,0,nil,i)
		local pg=mg:Filter(Auxiliary.GrandsCychroTargetCheckEffectFilter1,nil,i)
		local sg=Duel.GetMatchingGroup(Card.IsType,i,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
		for pc in aux.Next(pg) do 
			for sc in aux.Next(sg) do 
				if sc:IsSynchroSummonable(pc,mg) then 
					fg:AddCard(pc)
					break 
				end 
			end
		end 
	end
end
function Auxiliary.GrandsCychroTargetCheckTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g:IsContains(e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function Auxiliary.GrandsCychroTargetCheckOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local mg=Duel.GetMatchingGroup(Auxiliary.GrandsCychroTargetCheckEffectFilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
	local exg=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,nil)
	local scg=Group.CreateGroup()
	for fc in aux.Next(exg) do 
		if fc:IsSynchroSummonable(c,mg) then 
			scg:AddCard(fc)
		end 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=scg:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		Duel.SynchroSummon(tp,sc,c,mg)
	end
end
