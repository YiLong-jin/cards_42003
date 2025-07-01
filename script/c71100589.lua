--驱动女神@澄黄之心
function c71100589.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,71100589)	
	--cannot be link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,71100589) 
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e1:SetCost(c71100589.spcost)
	e1:SetTarget(c71100589.sptg)
	e1:SetOperation(c71100589.spop)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c71100589.atkcon)
	e2:SetOperation(c71100589.atkop) 
	c:RegisterEffect(e2)
end 
function c71100589.rlfil(c,e,tp) 
	return c:IsCode(71100585) and c:IsAttackAbove(e:GetHandler():GetAttack()) and c:IsFaceup() and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0
end 
function c71100589.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c71100589.rlfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectMatchingCard(tp,c71100589.rlfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
	Duel.Release(g,REASON_COST)
end 
function c71100589.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71100589.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100589.cfilter(c,g)
	return g:IsContains(c)
end
function c71100589.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c71100589.cfilter,1,nil,lg)
end
function c71100589.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup() 
	lg:AddCard(c) 
	if not lg then return end 
	local tc=lg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=lg:GetNext()
	end
end



