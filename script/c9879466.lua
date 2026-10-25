--蓝水晶骑士-莉薇儿
function c9879466.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879466,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9879466)
	e1:SetCost(c9879466.spcost)
	e1:SetTarget(c9879466.sptg)
	e1:SetOperation(c9879466.spop)
	c:RegisterEffect(e1)
	--spe 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1) 
	e2:SetTarget(c9879466.spetg)
	e2:SetOperation(c9879466.speop)
	c:RegisterEffect(e2)
end
function c9879466.cfilter(c,tp)
	return c:GetEquipCount()>0 and c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0 
end
function c9879466.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879466.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9879466.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9879466.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879466.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end
function c9879466.spetg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end 
	e:SetCategory(0)
	local c=e:GetHandler() 
	if c:IsSummonLocation(LOCATION_HAND) then 
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif c:IsSummonLocation(LOCATION_GRAVE) then 
		e:SetCategory(CATEGORY_ATKCHANGE)
	else 
		e:SetCategory(CATEGORY_TOHAND) 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	end 
end
function c9879466.thfil(c) 
	return c:IsAbleToHand() and c:IsAttack(500) and c:IsDefense(0) and c:IsRace(RACE_WARRIOR) 
end 
function c9879466.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonLocation(LOCATION_HAND) then 
		if Duel.IsExistingMatchingCard(c9879466.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then 
			local sg=Duel.SelectMatchingCard(tp,c9879466.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)
		end 
	elseif c:IsSummonLocation(LOCATION_GRAVE) then 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(1000) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_CHANGE_LEVEL) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(4) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1)
		end 
	else 
		if c:IsRelateToEffect(e) then 
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end 
	end 
end 





