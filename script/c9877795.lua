--拒绝契约的村正
function c9877795.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9877795+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9877795.negcost)
	e1:SetTarget(c9877795.tg)
	e1:SetOperation(c9877795.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c9877795.negcost1)
	e2:SetTarget(c9877795.thtg)
	e2:SetOperation(c9877795.thop)
	c:RegisterEffect(e2)
end
function c9877795.spfilter(c,e,tp)
	return c:IsSetCard(0x27eb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877795.cfilter(c)
	return c:GetType()&(TYPE_EQUIP)==TYPE_EQUIP and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function c9877795.cfilter1(c)
	return  c:IsLevel(2) and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGraveAsCost()
end
function c9877795.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877795.cfilter,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(c9877795.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c9877795.cfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c9877795.cfilter1,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=g+g1
		if g2:GetCount()>0 then
			local sg=g2:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_COST)
		end
end
function c9877795.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877795.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end
function c9877795.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877795.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9877795.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9877795.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end


function c9877795.negcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and (Duel.IsExistingMatchingCard(c9877795.cfilter,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(c9877795.cfilter1,tp,LOCATION_HAND,0,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c9877795.cfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c9877795.cfilter1,tp,LOCATION_HAND,0,nil,e,tp)
	local g3=Duel.GetMatchingGroup(c9877795.thfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	if g:GetCount()<2 then
		local g2=g1
		if g2:GetCount()>0 and Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)~=0 then
			local sg=g2:Select(tp,1,1,nil)	
			Duel.SendtoGrave(sg,REASON_COST)
		end
	else
		local g2=g+g1
		if g2:GetCount()>0 and Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)~=0 then
			if g3:GetCount()==1 then
			local g2=g2-g3
			local sg=g2:Select(tp,1,1,nil)	
				Duel.SendtoGrave(sg,REASON_COST)
			else
				local sg=g2:Select(tp,1,1,nil)	
				Duel.SendtoGrave(sg,REASON_COST)
			end
		end
	end
end


function c9877795.thfilter(c)
	return (c:IsSetCard(0x27eb) and c:GetOriginalType(TYPE_MONSTER) ) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c9877795.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877795.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function c9877795.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877795.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end