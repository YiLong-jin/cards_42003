--奸奇灵能使
function c21400104.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c) return c:IsLinkSetCard(0x3210) and not c:IsLinkType(TYPE_LINK) end,1) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400104)
	e1:SetTarget(c21400104.cntg)
	e1:SetOperation(c21400104.cnop)
	c:RegisterEffect(e1)
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11400104)
	e2:SetCondition(c21400104.spcon)
	e2:SetTarget(c21400104.sptg)
	e2:SetOperation(c21400104.spop)
	c:RegisterEffect(e2)
end 
function c21400104.cntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c21400104.cnop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) then 
		cn=1-Duel.SelectOption(tp,aux.Stringid(21400104,1),aux.Stringid(21400104,2))
	else 
		cn=Duel.TossCoin(tp,1) 
	end 
	if cn==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif cn==0 then
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end
function c21400104.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x3210) and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and p==tp and rp==1-tp
end
function c21400104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400104.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
