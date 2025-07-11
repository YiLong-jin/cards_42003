--堕香法师学徒·茉莉
function c9879081.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),4,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c9879081.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9879081.spcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)

	 local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(9879081,1))
	e14:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1,9879081)
	e14:SetCost(c9879081.negcost)
	e14:SetTarget(c9879081.tgtg1) 
	e14:SetOperation(c9879081.tgop1) 
	c:RegisterEffect(e14)
	
end

function c9879081.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end


function c9879081.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9879081.tgfil1(c) 
	return c:IsAbleToHand() and (c:IsSetCard(0x17ea) or c:IsSetCard(0xc9))
end 
function c9879081.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879081.tgfil1,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c9879081.tgop1(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879081.tgfil1,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg)
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9879081.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9879081.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end