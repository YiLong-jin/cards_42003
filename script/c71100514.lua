--全体开火
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
end
function this.filter(c)
	return c:IsSetCard(0x37d0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function this.actf(c)
	return c:IsSetCard(0x37d0) and c:IsAttackPos() 
end 
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,this.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		local tg=Duel.GetMatchingGroup(this.actf,tp,LOCATION_MZONE,0,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=tg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.HintSelection(sg)
			--destroy
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(id,1))
			e3:SetCategory(CATEGORY_DESTROY)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_NO_TURN_RESET)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			e3:SetTarget(this.destg)
			e3:SetOperation(this.desop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e3)
		end
	end
end
function this.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function this.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
