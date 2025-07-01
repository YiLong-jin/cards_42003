--律者杀手 华·迦楼罗
local m=99950370
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,2,2)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)


end
function cm.mfilter(c,xyzc)
	return c:IsSetCard(0x66c)
end
function cm.mtfilter(c,e)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.mgfilter(c)
	return c:IsType(TYPE_XYZ)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,e:GetHandler()):GetSum(Card.GetAttack)>0 end
	local mg=c:GetOverlayGroup()
	if mg:IsExists(cm.mgfilter,1,nil) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,c):GetSum(Card.GetAttack)
		local def=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,c):GetSum(Card.GetDefense)
		local atk1=atk+def
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk1/2)
		c:RegisterEffect(e1)
			local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,c)
			if #g>0 then Duel.BreakEffect() end
			for tc in aux.Next(g) do
			local atk2=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(math.ceil(atk2/2))
			tc:RegisterEffect(e1)
		end
	end
end