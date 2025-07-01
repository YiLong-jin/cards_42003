--死者的突击
local m=71100242
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.costfilter(c)
	return c:GetCounter(0x17d7)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x17d7,1,REASON_COST) end
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		local sct=tc:GetCounter(0x17d7)
		tc:RemoveCounter(tp,0x17d7,sct,REASON_COST)
		sum=sum+sct
		tc=g:GetNext()
	end
	e:SetLabel(sum)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel() or 0
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(ct)
	e1:SetValue(cm.aclimit)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterFlagEffect(tp,38572779,RESET_PHASE+PHASE_MAIN1,0,1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
		Duel.RegisterFlagEffect(tp,38572779,RESET_PHASE+PHASE_MAIN2,0,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	local pt=c:GetLevel()*2 or c:GetRank()*2 or c:GetLink()*4 or 0
	return re:IsActiveType(TYPE_MONSTER) and e:GetLabel()>pt and pt~=0
end