--炽天武装的裁判
function c10701078.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--change
	aux.EnableChangeCode(c,56433456,LOCATION_FZONE+LOCATION_GRAVE)  
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10701078.negcon)
	e2:SetOperation(c10701078.negop)
	c:RegisterEffect(e2)
	--change race or attribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701078,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,10701078)
	e3:SetTarget(c10701078.ctg)
	e3:SetOperation(c10701078.cop)
	c:RegisterEffect(e3)
end
function c10701078.cfilter(c)
	return c:IsFaceup() and not (c:IsAbleToDeck() or c:IsAbleToDeckAsCost())
end
function c10701078.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct>0 and ct==Duel.GetMatchingGroupCount(c10701078.cfilter,tp,LOCATION_MZONE,0,nil)
		and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and (re:GetActivateLocation()==LOCATION_HAND or re:GetActivateLocation()==LOCATION_GRAVE)
end
function c10701078.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10701078)
	local rc=re:GetHandler()
	Duel.NegateEffect(ev) 
end
function c10701078.chfilter(c)
	return (c:IsSetCard(0x7cf) and c:IsType(TYPE_MONSTER)) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c10701078.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701078.chfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local ar=0
	local op=Duel.SelectOption(tp,aux.Stringid(10701078,3),aux.Stringid(10701078,4))
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		ar=Duel.AnnounceRace(tp,1,RACE_ALL)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		ar=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	end
	e:SetLabel(op,ar)
end
function c10701078.cop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701078.chfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local c,op,ar=e:GetHandler(),e:GetLabel()
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10701078,2))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.HintSelection(sg)
		else
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		if op==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(ar)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(ar)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end