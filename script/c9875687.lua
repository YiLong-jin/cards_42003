--决意的启明星-阿尔卡娜
function c9875687.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()   
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)
	--to grave and sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(9875687,2))
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,9875687) 
	e2:SetTarget(c9875687.tgstg) 
	e2:SetOperation(c9875687.tgsop) 
	c:RegisterEffect(e2)	 
	--to grave and remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9875687,3))  
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,1875687)
	e3:SetTarget(c9875687.tgrtg) 
	e3:SetOperation(c9875687.tgrop)
	c:RegisterEffect(e3)  
end
function c9875687.tgfilter(c) 
	return c:IsSetCard(0x2ea7) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end 
function c9875687.tgstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9875687.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end  
function c9875687.tgsop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9875687.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9875687.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9875687.splimit(e,c)
	return not c:IsSetCard(0x2ea7) 
end 
function c9875687.tgfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave() 
end 
function c9875687.tgrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875687.tgfil,tp,LOCATION_SZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9875687.tgfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
end 
function c9875687.tgrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsCode(9875667) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875687,1)) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
	end 
end 












