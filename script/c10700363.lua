--光道枪士 范恩
function c10700363.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700363,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,10700324)
	e1:SetCondition(c10700363.condtion)
	e1:SetTarget(c10700363.target)
	e1:SetOperation(c10700363.operation)
	c:RegisterEffect(e1)  
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700363,1))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,10700325)
	e2:SetCondition(c10700363.drcon)
	e2:SetTarget(c10700363.drtg)
	e2:SetOperation(c10700363.drop)
	c:RegisterEffect(e2)	  
end
function c10700363.condtion(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c10700363.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10700363.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10700363.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO 
end
function c10700363.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c10700363.cfilter(c)
	return c:IsSetCard(0x38) and c:IsLocation(LOCATION_GRAVE)
end
function c10700363.atkfilter(c)
	return c:IsFaceup() 
end
function c10700363.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c10700363.cfilter,nil)
	local ag=Duel.GetMatchingGroup(c10700363.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=ag:GetFirst()
	if ct>0 then
		while tc do
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  e1:SetValue(300*ct)
		  tc:RegisterEffect(e1)
		  local e2=Effect.CreateEffect(e:GetHandler())
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_UPDATE_DEFENSE)
		  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		  e2:SetValue(300*ct)
		  tc:RegisterEffect(e2)
		  tc=ag:GetNext()
		end
	end
end