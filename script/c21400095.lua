--纳垢魔域-奇异花园
function c21400095.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21400095+EFFECT_COUNT_CODE_OATH) 
	e1:SetOperation(c21400095.acop)
	c:RegisterEffect(e1)	
	--ct
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c21400095.ctcon)
	e1:SetOperation(c21400095.ctop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2)
	--revive
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,11400095) 
	e2:SetTarget(c21400095.sptg)
	e2:SetOperation(c21400095.spop)
	c:RegisterEffect(e2)
end
function c21400095.acfilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end 
function c21400095.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end 
	if Duel.IsExistingMatchingCard(c21400095.acfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21400095,0)) then  
		local g=Duel.SelectMatchingCard(tp,c21400095.acfilter,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c21400095.ctcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsCanAddCounter(0x1077,eg:GetCount())
end 
function c21400095.ctop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsCanAddCounter(0x1077,eg:GetCount()) then 
		Duel.Hint(HINT_CARD,0,21400095) 
		c:AddCounter(0x1077,eg:GetCount()) 
	end 
end 
function c21400095.spfilter(c,e,tp)
	return c:IsSetCard(0x9210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400095.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c21400095.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c21400095.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21400095.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21400095.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end 
end



