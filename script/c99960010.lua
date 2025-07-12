--创世神的一页
local s,id,o=GetID()
shenqi_Savior=shenqi_Savior or {}
function s.initial_effect(c)
		--Activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_ACTIVATE)
	e9:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e9)
		--levelup()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(1)
	e1:SetTarget(s.rmtg)
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	
		--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99960010,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,99960010)
	e3:SetCost(s.costt)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)

	--special summon xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99960010,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,99990011+EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
--[[		if shenqi_Savior.global_check then return end 
		shenqi_Savior.global_check= {{},{}}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(shenqi_Savior.op_hint)
		Duel.RegisterEffect(ge1,0)]]
end

function s.filter(c,e,tp,rc)
	return c.Savior_mojie and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.mtfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e) and c.Savior_mojie
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mtfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,tc,e)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local xg=mg:Select(tp,1,1,nil)
			local tc1=xg:GetFirst()
			while tc1 do
				tc1:CancelToGrave()
				local og=tc1:GetOverlayGroup()
				if #og>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc1=xg:GetNext()
			end
			Duel.Overlay(tc,xg)
		end
	end
end







function s.rmtg(e,c)
	return (c.Savior_mojie or c:IsCode(99960090)) and c:IsType(TYPE_MONSTER)
end
function s.costt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if chk==0 then return c1g:GetCount()>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c1g:Select(tp,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(99960010,4))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
function s.filter1(c)
	return c.Savior_mojie and c:IsAbleToHand()
end

---------------mojie_COST--------------------魔法卡cost
function shenqi_Savior.spellcost1(e,tp,eg,ep,ev,re,r,rp,chk)--神的考验专用
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=fa-fb
	if chk==0 then return fc<2 end
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
end
function shenqi_Savior.spellcost2(e,tp,eg,ep,ev,re,r,rp,chk)--魔神诵专用
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=fa-fb
	if chk==0 then return fc<1 and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
end
function shenqi_Savior.spellcost3(e,tp,eg,ep,ev,re,r,rp,chk)--消歧义专用
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=fa-fb
	local fd=fb-fa
	if chk==0 then return fc<-1 and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
end
function shenqi_Savior.spellcost4(e,tp,eg,ep,ev,re,r,rp,chk)--创世纪专用
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=fa-fb
	local fd=fb-fa
	if chk==0 then return fc<0 end
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
end

-----------------------------怪兽全局标识提示-------------------------------
--[[function shenqi_Savior.op_hint(e,tp,eg,ep,ev,re,r,rp)
	shenqi_Savior.SetHint(e:GetHandler(), 0)
	shenqi_Savior.SetHint(e:GetHandler(), 1)
end
function shenqi_Savior.SetHint(c, tp)
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=3-fa+fb
	for _, e in ipairs(shenqi_Savior.global_check[tp + 1]) do
		e:Reset()
	end
	local lst = {}
	if fc>0 then
		local e = Effect.CreateEffect(c)
		e:SetType(EFFECT_TYPE_FIELD)
		e:SetDescription(aux.Stringid(99960010,7))
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e:SetTargetRange(1,0)
		Duel.RegisterEffect(e,tp)
		table.insert(lst, e)
	end
	if fc<1 then
		local e = Effect.CreateEffect(c)
		e:SetType(EFFECT_TYPE_FIELD)
		e:SetDescription(aux.Stringid(99960010,8))
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e:SetTargetRange(1,0)
		Duel.RegisterEffect(e,tp)
		table.insert(lst, e)
	end
	----------------神的考验--------------------
		if fc>1 then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(aux.Stringid(99960120,1))
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		table.insert(lst, e1)
	end
		if fc<2 then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(aux.Stringid(99960120,2))
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		table.insert(lst, e1)
	end
	-----------------真魔法·魔神诵-------------------------
		if fc>2 then
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetDescription(aux.Stringid(99960130,0))
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
		table.insert(lst, e2)
	end
		if fc<3 then
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetDescription(aux.Stringid(99960130,1))
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
		table.insert(lst, e2)
	end
	---------------真魔法·消歧义--------------------------
		if fc>4 then
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetDescription(aux.Stringid(99960140,0))
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
		table.insert(lst, e3)
	end
		if fc<5 then
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetDescription(aux.Stringid(99960140,1))
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
		table.insert(lst, e3)
	end
	---------------真魔法·创世纪-------------------
		if fc>3 then
		local e4 = Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetDescription(aux.Stringid(99960180,2))
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e4:SetTargetRange(1,0)
		Duel.RegisterEffect(e4,tp)
		table.insert(lst, e4)
	end
	if fc<4 then
		local e4 = Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetDescription(aux.Stringid(99960180,3))
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e4:SetTargetRange(1,0)
		Duel.RegisterEffect(e4,tp)
		table.insert(lst, e4)
	end
	shenqi_Savior.global_check[tp + 1] = lst
end
]]





-------------------------怪兽cost--------------------
function shenqi_Savior.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)--怪兽效果取除素材和消耗次数专用
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=fa-fb
	if chk==0 then return fc<3 and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
end
function shenqi_Savior.cost(e,tp,eg,ep,ev,re,r,rp,chk)--怪兽效果消耗次数专用
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
end
function shenqi_Savior.cost1(e,tp,eg,ep,ev,re,r,rp,chk)--神话幻想专用
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(24,0,aux.Stringid(99960010,6))
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(24,0,aux.Stringid(99960010,6))
end
function shenqi_Savior.cost2(e,tp,eg,ep,ev,re,r,rp,chk)--不可思议爱丽丝专用
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=fa-fb
	if chk==0 then return fc<3 and Duel.IsExistingMatchingCard(shenqi_Savior.costfilter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(shenqi_Savior.costfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.RegisterFlagEffect(tp,99960010,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,5))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.costfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,shenqi_Savior.costfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g1,REASON_COST)
end
function shenqi_Savior.cost3(e,tp,eg,ep,ev,re,r,rp,chk)--不可思议神绮专用
	if chk==0 then return Duel.IsExistingMatchingCard(shenqi_Savior.costfilter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(shenqi_Savior.costfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(shenqi_Savior.costfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.costfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,shenqi_Savior.costfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,shenqi_Savior.costfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g2,REASON_COST)
end
function shenqi_Savior.con(e,tp,eg,ep,ev,re,r,rp)--怪兽作为cost送墓诱发专用
	return e:GetHandler():IsReason(REASON_COST)
end
function shenqi_Savior.costfilter2(c)--送墓本家怪兽检测`爱丽丝
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and (c.Savior_mojie or c:IsCode(99960090)) and not c:IsCode(99960160)
end
function shenqi_Savior.costfilter1(c)--送墓本家怪兽检测`神绮
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c.Savior_mojie
end

------------------------特召手续--------------------------------------
function shenqi_Savior.spcon1(e,c,mc)-----2素材xyz使用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(shenqi_Savior.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil,tp)
end
function shenqi_Savior.spcon2(e,c,mc)------3素材xyz使用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(shenqi_Savior.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,3,nil,tp)
end
function shenqi_Savior.spcon3(e,c,mc)------魔界的创世神·神绮专用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(shenqi_Savior.spfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,5,nil,tp)
end
function shenqi_Savior.spfilter1(c,tp)-----素材检测
	return (c.Savior_mojie or c:IsCode(99960090)) and ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_MONSTER)
end
function shenqi_Savior.spfilter2(c,tp)------魔界创世神神绮专用素材检测
	return (c.Savior_mojie or c:IsCode(99960090)) and ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_HAND)) and (c:IsLevel(1) or c:IsRank(1))
end
function shenqi_Savior.spop1(e,tp,eg,ep,ev,re,r,rp,c)-------2素材xyz使用选择素材
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil,tp)
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g)
end
function shenqi_Savior.spop2(e,tp,eg,ep,ev,re,r,rp,c)--------3素材xyz使用选择素材
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,3,3,nil,tp)
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g)
end
function shenqi_Savior.spop3(e,tp,eg,ep,ev,re,r,rp,c)-------创世神神绮专用选择素材
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.spfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,5,5,nil,tp)
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g)
end
function shenqi_Savior.xyzop(e,tp,eg,ep,ev,re,r,rp)--------特殊召唤成功时叠放素材
	local c=e:GetHandler()
	local pg=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg>0 then
		for tc in aux.Next(pg) do
			local mg=tc:GetOverlayGroup()
			Duel.Overlay(c,mg)
			Duel.Overlay(c,tc)
		end
		pg:Clear()
	end 
end

--[[function shenqi_Savior.xyzop1(e,tp,eg,ep,ev,re,r,rp)--------特殊召唤成功时叠放素材
	local c=e:GetHandler()
	local pg1=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg1>0 then
		for tc in aux.Next(pg1) do
			Duel.Overlay(c,tc)
		end
		pg1:Clear()
	end 
end]]
----------------------------创世神的一页效果使用中的特召手续----------------------------
function shenqi_Savior.spcon11(e,c,mc)-----2素材xyz使用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(shenqi_Savior.spfilter11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,99960010)
end
--[[function shenqi_Savior.spcon21(e,c,mc)------3素材xyz使用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(shenqi_Savior.spfilter11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,99960010)
end]]
--[[function shenqi_Savior.spcon31(e,c,mc)------魔界的创世神·神绮专用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(shenqi_Savior.spfilter21,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,99960010)
end]]
function shenqi_Savior.spfilter11(c,tp)-----素材检测
	return c.Savior_mojie and c:IsType(TYPE_MONSTER)
end
--[[function shenqi_Savior.spfilter21(c,tp)------魔界创世神神绮专用素材检测
	return c.Savior_mojie and (c:IsLevel(1) or c:IsRank(1))
end]]
function shenqi_Savior.spop11(e,tp,eg,ep,ev,re,r,rp,c)-------2素材xyz使用选择素材
	Duel.Hint(HINT_CARD,1-tp,99960010)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.spfilter11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	local pg1=e:GetLabelObject()
	pg1:Clear()
	pg1:Merge(g)
end
--[[function shenqi_Savior.spop21(e,tp,eg,ep,ev,re,r,rp,c)--------3素材xyz使用选择素材
	Duel.Hint(HINT_CARD,1-tp,99960010)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.spfilter11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g)
end]]
--[[function shenqi_Savior.spop31(e,tp,eg,ep,ev,re,r,rp,c)-------创世神神绮专用选择素材
	Duel.Hint(HINT_CARD,1-tp,99960010)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,shenqi_Savior.spfilter21,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil,tp)
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g)
end]]


