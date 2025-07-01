--妖精圆桌骑士 梅柳齐娜
function c4429659.initial_effect(c) 
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),7,2) 
	c:EnableReviveLimit()   
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4429659,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,4429659)
	e1:SetCondition(c4429659.discon)
	e1:SetCost(c4429659.discost)
	e1:SetTarget(c4429659.distg)
	e1:SetOperation(c4429659.disop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,1429659) 
	e2:SetCondition(c4429659.spcon)
	e2:SetTarget(c4429659.sptg)  
	e2:SetOperation(c4429659.spop)  
	c:RegisterEffect(e2) 
end
function c4429659.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c4429659.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4429659.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c4429659.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.NegateActivation(ev) 
	if c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,4409659) and re:GetHandler():IsRelateToEffect(re) then 
	Duel.Hint(HINT_CARD,0,4409659)
	Duel.Destroy(re:GetHandler(),REASON_EFFECT)  
	Duel.Damage(1-tp,re:GetHandler():GetAttack(),REASON_EFFECT) 
	end  
end 
function c4429659.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c4429659.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(4439659) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end 
function c4429659.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4429659.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end 
function c4429659.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c4429659.spfil,tp,LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end 
end 
 



