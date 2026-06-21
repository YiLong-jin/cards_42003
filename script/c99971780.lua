--决心之誓·米莉亚姆
function c99971780.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99971780,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(1)
	e1:SetCondition(c99971780.thcon)
	e1:SetCost(c99971780.thcost)
	e1:SetTarget(c99971780.thtg)
	e1:SetOperation(c99971780.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99971780,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(2)
	e2:SetTarget(c99971780.thtg)
	e2:SetOperation(c99971780.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)		
end
function c99971780.thfilter2(c,tp,ft)
	return c:IsCode(99971660) and c:IsAbleToHand() and c:IsFaceupEx() and Duel.IsExistingMatchingCard(c99971780.thfilter2a,tp,LOCATION_DECK+ft,0,1,nil)
end
function c99971780.thfilter2a(c)
	return c:IsCode(99971670) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c99971780.thfilter2t(c)
	return c:IsCode(99971660) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c99971780.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=nil
	if e:GetLabel()==1 then ft=LOCATION_REMOVED elseif e:GetLabel()==2 then ft=LOCATION_GRAVE end
	if chk==0 then return Duel.IsExistingMatchingCard(c99971780.thfilter2,tp,LOCATION_DECK+ft,0,1,nil,tp,ft)
	and Duel.GetFlagEffect(tp,99971780+e:GetLabel())==0 end
	Duel.RegisterFlagEffect(tp,99971780+e:GetLabel(),RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+ft)
end
function c99971780.fselect(g)
	return g:FilterCount(c99971780.thfilter2t,nil)==1
end
function c99971780.thop(e,tp,eg,ep,ev,re,r,rp)
	local ft=nil
	if e:GetLabel()==1 then ft=LOCATION_REMOVED elseif e:GetLabel()==2 then ft=LOCATION_GRAVE end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c) return c:IsCode(99971670) and c:IsAbleToHand() end),tp,LOCATION_DECK+ft,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c) return c:IsCode(99971660) and c:IsAbleToHand() end),tp,LOCATION_DECK+ft,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		local g=Group.__add(g1,g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c99971780.fselect,false,2,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c99971780.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkState()
end
function c99971780.cffilter(c,tp)
	return c:IsRace(0x20) and c:IsSetCard(0x67f)
end
function c99971780.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c99971780.cffilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c99971780.cffilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end