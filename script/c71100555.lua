--残酷机壳的行动纲领
function c71100555.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71100555+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c71100555.tetg)
	e1:SetOperation(c71100555.teop)
	c:RegisterEffect(e1)  
	--tdth 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c71100555.tdhtg)
	e2:SetOperation(c71100555.tdhop)
	c:RegisterEffect(e2)  
	--set 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCondition(c71100555.setcon)
	e3:SetTarget(c71100555.settg)
	e3:SetOperation(c71100555.setop)
	c:RegisterEffect(e3)
end
function c71100555.tefilter(c) 
	return c:IsSetCard(0xaa) and c:IsType(TYPE_PENDULUM)  
end
function c71100555.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100555.tefilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_DECK)
end
function c71100555.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.SelectMatchingCard(tp,c71100555.tefilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end  
function c71100555.thfil(c) 
	return c:IsFaceup() and c:IsAbleToHand()  
end 
function c71100555.tdhgck(g,tp) 
	return Duel.IsExistingMatchingCard(c71100555.thfil,tp,LOCATION_EXTRA,0,g:GetCount()+1,nil)
end 
function c71100555.tdhtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(c71100555.tdhgck,1,99,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c71100555.tdhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:CheckSubGroup(c71100555.tdhgck,1,99,tp) then
		local rg=g:SelectSubGroup(tp,c71100555.tdhgck,false,1,99,tp) 
		if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c71100555.thfil,tp,LOCATION_EXTRA,0,rg:GetCount()+1,nil) then 
			Duel.BreakEffect() 
			local sg=Duel.SelectMatchingCard(tp,c71100555.thfil,tp,LOCATION_EXTRA,0,rg:GetCount()+1,rg:GetCount()+1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end
end
function c71100555.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)  
end 
function c71100555.setfilter(c)
	return c:IsSetCard(0xaa) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c71100555.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c71100555.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c71100555.setfilter,tp,LOCATION_DECK,0,1,nil) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c71100555.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end 
	end 
end



