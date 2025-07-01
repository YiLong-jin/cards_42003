--阴云仙－层状云
function c10701691.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),5,1,nil,nil,99)  
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701691,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10701691)
	e1:SetCondition(c10701691.poscon)
	e1:SetCost(c10701691.poscost)
	e1:SetTarget(c10701691.postg)
	e1:SetOperation(c10701691.posop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c10701691.poscon2)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701691,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10701692)
	e3:SetTarget(c10701691.ovtg)
	e3:SetOperation(c10701691.ovop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701691,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10701691.atcon)
	e4:SetTarget(c10701691.attg)
	e4:SetOperation(c10701691.atop)
	c:RegisterEffect(e4)	 
end
function c10701691.poscon(e)
	return e:GetHandler():GetOverlayCount()<3
end
function c10701691.poscon2(e)
	return e:GetHandler():GetOverlayCount()>=3
end
function c10701691.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=c:GetOverlayGroup()
	local ct=Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(ct)
end
function c10701691.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10701691.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c10701691.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,ct,1,0,0)
end
function c10701691.posop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c10701691.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local tc=g:GetCount()
		local pg=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc,nil)
		if pg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701691,3)) then
			Duel.ChangePosition(pg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end
end
function c10701691.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function c10701691.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c10701691.ofilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT) end
end
function c10701691.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c10701691.ofilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e)
		local tc=g:GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c10701691.atcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c10701691.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED,0)
	if chk==0 then return #g>0 end
end
function c10701691.atfilter(c)
	return c:IsCanOverlay()
end
function c10701691.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701691.atfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if #mg>0 then
		Duel.Overlay(c,mg)
	end
end