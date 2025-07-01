--利威坦之影灵衣
function c10701256.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--special summon 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701256,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10701256)
	e2:SetCost(c10701256.spcost)
	e2:SetTarget(c10701256.sptg)
	e2:SetOperation(c10701256.spop)
	c:RegisterEffect(e2) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52068432,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,10701257)
	e3:SetCondition(c10701256.thcon)
	e3:SetTarget(c10701256.thtg)
	e3:SetOperation(c10701256.thop)
	c:RegisterEffect(e3)   
end
function c10701256.mat_filter(c)
	return not c:IsLevel(10)
end
function c10701256.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c10701256.spfilter(c,e,tp)
	return c:IsSetCard(0xb4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701256.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701256.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10701256.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701256.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701256.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c10701256.thfilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToHand()
end
function c10701256.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701256.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10701256.pbfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10701256.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701256.thfilter),tp,LOCATION_GRAVE,0,1,3,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:FilterCount(c10701256.pbfilter,nil)>0 
			and Duel.SelectYesNo(tp,aux.Stringid(10701256,2)) then
			Duel.ConfirmCards(1-tp,g)
			local sg=g:FilterSelect(tp,c10701256.pbfilter,1,3,nil)
			local tc=sg:GetFirst()
			while tc do
			   local e1=Effect.CreateEffect(tc)  
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetCode(EFFECT_PUBLIC)
			   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e1)
			   local e2=Effect.CreateEffect(tc)
			   e2:SetType(EFFECT_TYPE_SINGLE)
			   e2:SetCode(EFFECT_CHANGE_LEVEL)
			   e2:SetValue(2)
			   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e2)
			   tc:RegisterFlagEffect(10701256,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10701256,4))
			   tc=sg:GetNext()
			end
		end
	end
end