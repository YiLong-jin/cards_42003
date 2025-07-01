--妖精圆桌骑士 巴格斯特
function c4428659.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),5,2) 
	c:EnableReviveLimit()   
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,4428659)   
	e1:SetCost(c4428659.atkcost)
	e1:SetTarget(c4428659.atktg) 
	e1:SetOperation(c4428659.atkop) 
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval) 
	e2:SetCondition(c4428659.xctcon)
	--c:RegisterEffect(e2)
end
function c4428659.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4428659.atkf(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function c4428659.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4428659.atkf,tp,0,LOCATION_MZONE,1,nil) end  
end 
function c4428659.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c4428659.atkf,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then  
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	local atk=tc:GetAttack() 
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(atk) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	if c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,4408659) then 
	Duel.Hint(HINT_CARD,0,4408659)  
	Duel.BreakEffect() 
	Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT) 
	Duel.Destroy(tc,REASON_EFFECT) 
	end 
	end 
	end 
end 
function c4428659.xctcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end 












