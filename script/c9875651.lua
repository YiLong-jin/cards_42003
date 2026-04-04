--胆小和笨蛋
function c9875651.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	 local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9875651)  
	e2:SetCondition(c9875651.spcon)
	e2:SetTarget(c9875651.sptg) 
	e2:SetOperation(c9875651.spop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 

	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,1875651)
	e4:SetCondition(c9875651.condition)
	e4:SetTarget(c9875651.target)
	e4:SetOperation(c9875651.activate)
	c:RegisterEffect(e4)
end
c9875651.SetCard_bzdsmgdyd=true 
function c9875651.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)  
end  
function c9875651.rettfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelBelow(4) and not (c:IsRace(RACE_ROCK) or c:IsRace(RACE_FIEND)) and c:IsSummonable(true,nil)
end
function c9875651.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9875651.rettfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0) 
end 
function c9875651.spop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9875651.rettfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 

function c9875651.cfilter(c)
	return c:IsFaceup() and (c:IsCode(9875646) or c:IsCode(9875645))
end
function c9875651.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9875651.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9875651.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
end
function c9875651.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Recover(1-tp,1000,REASON_EFFECT)
	end
end