--真实的使徒
function c17030860.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17030860,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,17030860)
	e1:SetCondition(c17030860.thcon)
	e1:SetTarget(c17030860.thtg)
	e1:SetOperation(c17030860.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetLabelObject(e1)
	e2:SetOperation(c17030860.dop)
	Duel.RegisterEffect(e2,tp)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c17030860.acop)
	c:RegisterEffect(e4)
	--counter move
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(5206415,1))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c17030860.coucon)
	e6:SetTarget(c17030860.coutg)
	e6:SetOperation(c17030860.couop)
	c:RegisterEffect(e6)
end
function c17030860.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c17030860.dop(e,tp,eg)
	local num=0
	for tc in aux.Next(eg) do
		if e:GetHandler():GetMaterial():IsContains(tc) then
			local count=tc:GetCounter(0x1)
			num=num+count
		end
	end
	e:GetLabelObject():SetLabel(num)
end
function c17030860.thfilter(c,check)
	return c:IsAbleToHand() and (c:IsSetCard(0x57f3) or c:IsCode(37115575) or (check and c:IsCanHaveCounter(0x1)))
end
function c17030860.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>8 then c:RegisterFlagEffect(17030860,RESET_CHAIN,0,1) end
	if chk==0 then
		local check=c:GetFlagEffect(17030860)>0
		return Duel.IsExistingMatchingCard(c17030860.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17030860.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=c:GetFlagEffect(17030860)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17030860.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17030860.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c17030860.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local ct=c:GetCounter(0x1)
	c:RemoveCounter(tp,0x1,ct,REASON_EFFECT)
	rc:AddCounter(0x1,ct)
end
function c17030860.coucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c17030860.coutg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(0x1)>0 and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,nil,0x1,1) end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x1,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
end
function c17030860.couop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	if ct>0 and c:RemoveCounter(tp,0x1,ct,REASON_EFFECT)~=0 
		and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,c,0x1,1)>0 then
		while ct>0 do
			local cout=1
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,1,c,0x1,1):GetFirst()
			if not tc then break end
			if Duel.SelectYesNo(tp,aux.Stringid(17030860,2)) then cout=ct end
			tc:AddCounter(0x1,cout)
			ct=ct-cout
		end
	end
end
