--驱动女神@虹之心
function c71100587.initial_effect(c)
	c:SetUniqueOnField(1,0,71100587)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE) 
	e1:SetCondition(c71100587.hspcon)
	e1:SetOperation(c71100587.hspop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,71100587)
	e2:SetCost(c71100587.thcost)
	e2:SetTarget(c71100587.thtg)
	e2:SetOperation(c71100587.thop)
	c:RegisterEffect(e2) 
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsRace(RACE_FAIRY) end,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)*500 end)
	c:RegisterEffect(e2) 
	--dam 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c71100587.damcon) 
	e3:SetOperation(c71100587.damop)
	c:RegisterEffect(e3) 
end
function c71100587.ctfil(c)
	return (c:IsRace(RACE_FAIRY) or c:IsSummonLocation(LOCATION_EXTRA)) and c:IsReleasable()
end 
function c71100587.ctgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0
end 
function c71100587.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c71100587.ctfil,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c71100587.ctgck,2,2,tp)
end
function c71100587.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c71100587.ctfil,tp,LOCATION_MZONE,0,nil) 
	local rg=g:SelectSubGroup(tp,c71100587.ctgck,false,2,2,tp) 
	Duel.Release(rg,REASON_COST) 
end
function c71100587.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c71100587.thfil(c)
	return c:IsLevel(4) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand() 
end
function c71100587.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100587.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71100587.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71100587.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71100587.damcon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end 
function c71100587.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.Hint(HINT_CARD,0,71100587) 
	Duel.Damage(1-tp,600,REASON_EFFECT)
end 
