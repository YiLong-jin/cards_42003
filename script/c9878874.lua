--银月鬼杀者-青鹤壶
function c9878874.initial_effect(c)
	 aux.AddCodeList(c,9877864) 
	--battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1) 
	e1:SetCondition(c9878874.ckcon)
	c:RegisterEffect(e1)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(1)
	e1:SetCondition(c9878874.ckcon)
	c:RegisterEffect(e1) 
	--atk 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1000) 
	e1:SetCondition(c9878874.ckcon)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1000) 
	e1:SetCondition(c9878874.ckcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878874,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9878874)
	e2:SetCondition(c9878874.srcon)
	e2:SetTarget(c9878874.srtg)
	e2:SetOperation(c9878874.srop)
	c:RegisterEffect(e2)
end
function c9878874.ckfil(c) 
	return c:IsFaceup() and aux.IsCodeListed(c,9877864)  
end  
function c9878874.ckcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c9878874.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler())  
end 
function c9878874.srcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9878874.srfilter(c)
	return aux.IsCodeListed(c,9877864) and not c:IsCode(9878874) and c:IsAbleToHand()
end
function c9878874.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878874.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9878874.sspfil(c,e,tp)
	return aux.IsCodeListed(c,9877864) and not c:IsCode(9878874) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c9878874.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878874.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g) 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9878874.sspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9878874,0)) then 
			local tc=Duel.SelectMatchingCard(tp,c9878874.sspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst() 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end 
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9878874.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9878874.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) 
end
