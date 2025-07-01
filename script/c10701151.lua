--炼金釜－混沌提炼
function c10701151.initial_effect(c)
	aux.AddCodeList(c,10701151)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10701151.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetTarget(c10701151.rmtg)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701151,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,10701151)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c10701151.tg)
	e3:SetOperation(c10701151.op)
	c:RegisterEffect(e3)   
end
function c10701151.rmtg(e,c)
	return c:GetOwner()==e:GetHandlerPlayer()
end
function c10701151.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701151,1)) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c10701151.cfilter(c)
	return c:IsFaceup() 
end
function c10701151.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c10701151.cfilter,tp,LOCATION_REMOVED,0,nil)
		local ct=g:GetClassCount(Card.GetAttribute)
		return ct>=3
	end
end
function c10701151.tffilter(c,tp)
	return c:IsCode(30241314)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c10701151.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701151.cfilter,tp,LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetAttribute)
	local b1=ct>=4
	local b2=ct>=5 and Duel.IsPlayerCanDraw(tp,1)
	local b3=ct>=6 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10701151.tffilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp)
	if b1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(HALF_DAMAGE)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
	if b2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if b3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c10701151.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(10701151)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end