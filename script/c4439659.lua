--终焉之龙 阿尔比恩
function c4439659.initial_effect(c)
	c:EnableCounterPermit(0xad7)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),7,3) 
	c:EnableReviveLimit()   
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--damage val
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3) 
	--des 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,4439659)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetTarget(c4439659.destg)
	e4:SetOperation(c4439659.desop)
	c:RegisterEffect(e4) 
	--to grave  
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION) 
	e5:SetRange(LOCATION_MZONE) 
	e5:SetCountLimit(1,1439659) 
	e5:SetCost(c4439659.tgcost)
	e5:SetTarget(c4439659.tgtg) 
	e5:SetOperation(c4439659.tgop) 
	c:RegisterEffect(e5) 
end 
function c4439659.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c4439659.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,e:GetHandler())  
	if c:IsRelateToEffect(e) and c:AddCounter(0xad7,1) and g:GetCount()>0 then 
	Duel.BreakEffect() 
	Duel.Destroy(g,REASON_EFFECT) 
	end 
end 
function c4439659.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xad7,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xad7,3,REASON_COST) 
end 
function c4439659.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end 
function c4439659.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0 then 
	Duel.SendtoGrave(g,REASON_EFFECT) 
	end 
end 

  




 