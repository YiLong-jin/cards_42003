--叛逆特警-凯拉·科伦
function c9877846.initial_effect(c)
	c:EnableReviveLimit()  
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877846,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9877846) 
	e1:SetTarget(c9877846.destg)
	e1:SetOperation(c9877846.desop)
	c:RegisterEffect(e1)  
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877846,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9877846)
	e2:SetCondition(c9877846.discon)
	e2:SetCost(c9877846.discost)
	e2:SetTarget(c9877846.distg)
	e2:SetOperation(c9877846.disop)
	c:RegisterEffect(e2)
end
function c9877846.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9877846.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP) 
	local ag=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x17ec) end,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetTurnPlayer()==1-tp and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and ag:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877846,2)) then 
		Duel.BreakEffect()
		local tc=ag:GetFirst() 
		while tc do 
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9877846,3))
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=ag:GetNext() 
		end 
	end
end
function c9877846.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end
function c9877846.discon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsChainNegatable(ev) and rp==1-tp and re:IsActiveType(TYPE_SPELL)) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if not te or p~=tp then return false end 
	return te:IsActiveType(TYPE_MONSTER) 
end
function c9877846.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9877846.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.IsPlayerCanDraw(tp,1) and Duel.CheckLPCost(tp,2000) then 
		Duel.BreakEffect() 
		Duel.PayLPCost(tp,2000) 
		Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end
