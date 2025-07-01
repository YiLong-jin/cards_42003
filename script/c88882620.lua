--神秘面具男［忍者之路］
function c88882620.initial_effect(c) 
	aux.AddCodeList(c,88882620)
	c:SetUniqueOnField(1,0,88882620) 
	c:EnableCounterPermit(0x18a0)
	c:SetCounterLimit(0x18a0,4) 
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88882620) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCondition(function(e) 
	return Duel.GetMatchingGroupCount(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==0 end)
	e1:SetCost(c88882620.spcost)
	e1:SetTarget(c88882620.sptg) 
	e1:SetOperation(c88882620.spop) 
	c:RegisterEffect(e1) 
	--counter 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_COUNTER)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c88882620.sectg) 
	e2:SetOperation(c88882620.secop) 
	c:RegisterEffect(e2)  
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	--search
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(88882620,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,18882620)
	e3:SetCost(c88882620.thcost)
	e3:SetTarget(c88882620.thtg)
	e3:SetOperation(c88882620.thop)
	c:RegisterEffect(e3)  
	--counter and atk 
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(88882620,2))
	e4:SetCategory(CATEGORY_DAMAGE) 
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)  
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCondition(c88882620.ctcon)
	e4:SetTarget(c88882620.cttg)  
	e4:SetOperation(c88882620.ctop) 
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(88882620,2))
	e4:SetCategory(CATEGORY_DAMAGE) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c88882620.ctcon1)
	e4:SetTarget(c88882620.cttg)  
	e4:SetOperation(c88882620.ctop) 
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(88882620,ACTIVITY_SPSUMMON,c88882620.counterfilter)
end
function c88882620.counterfilter(c)
	return c:GetBaseAttack()==2100 and c:GetBaseDefense()==2000 
end
function c88882620.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(88882620,tp,ACTIVITY_SPSUMMON)==0 end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return not (c:GetBaseAttack()==2100 and c:GetBaseDefense()==2000) end) 
	Duel.RegisterEffect(e1,tp) 
end
function c88882620.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c88882620.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end 
end 
function c88882620.sectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x18a0,2) end 
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,0x18a0,2) 
end   
function c88882620.stgfil(c) 
	return c:IsAbleToGrave() and aux.IsCodeListed(c,88882620)   
end 
function c88882620.secop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
		c:AddCounter(0x18a0,2)   
	end 
end 
function c88882620.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x18a0,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x18a0,1,REASON_COST)
end
function c88882620.thfilter(c)
	return aux.IsCodeListed(c,88882620) and c:IsAbleToHand()
end
function c88882620.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88882620.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88882620.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88882620.thfilter,tp,LOCATION_DECK,0,1,1,nil) 
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g) 
	end 
end 
function c88882620.ctckfil(c,tp) 
	return c:IsType(TYPE_MONSTER) and c:IsOnField() and c:IsControler(1-tp) 
end 
function c88882620.ctcon(e,tp,eg,ep,ev,re,r,rp) 
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local rc=re:GetHandler()
	return rc and aux.IsCodeListed(rc,88882620) and not rc:IsCode(88882620)
end
function c88882620.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end 
function c88882620.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x18a0,1) end 
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,0x18a0,1) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,400) 
end   
function c88882620.ctop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()   
	Duel.Damage(tp,400,REASON_EFFECT) 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
		c:AddCounter(0x18a0,1)  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(400) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)		  
	end 
end 














