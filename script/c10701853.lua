--圣诞夜想曲的游行
function c10701853.initial_effect(c)
	aux.AddCodeList(c,46565218)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701853+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10701853.activate)
	c:RegisterEffect(e1) 
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c10701853.fliptg)
	c:RegisterEffect(e2) 
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10701853.fliptg)
	c:RegisterEffect(e3) 
	--flip flag
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FLIP)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c10701853.flipop)
	c:RegisterEffect(e4)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e3:SetLabelObject(ng)
	e4:SetLabelObject(ng) 
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(58481572,1))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c10701853.poscon)
	e5:SetTarget(c10701853.postg)
	e5:SetOperation(c10701853.posop)
	c:RegisterEffect(e5)
end
function c10701853.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x27c9) or c:IsCode(46565218)) and c:IsAbleToHand()
end
function c10701853.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701853.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701853,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c10701853.reset(e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if c:GetFlagEffectLabel(id)~=fid then
		e:GetLabelObject():Clear()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
end
function c10701853.flipop(e,tp,eg,ep,ev,re,r,rp)
	c10701853.reset(e)
	local ng=e:GetLabelObject()
	local tc=eg:GetFirst()
	while tc do
		ng:AddCard(tc)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=eg:GetNext()
	end
end
function c10701853.fliptg(e,c)
	c10701853.reset(e)
	return c:GetFlagEffect(id)>0 and e:GetLabelObject():IsContains(c) and c:IsSetCard(0x27c9)
end
function c10701853.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c10701853.posfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c10701853.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10701853.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701853.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetTargetCard(eg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c10701853.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c10701853.cfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsPublic()
end
function c10701853.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c10701853.cfilter,nil,e,1-tp)
	local tc=Duel.GetFirstTarget()
	if sg:GetCount()>0 then
		local hc=sg:GetFirst()
		while hc do
		 local e1=Effect.CreateEffect(tc)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_PUBLIC)
		 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		 hc:RegisterEffect(e1)
		 hc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(10701853,4))
		 hc=sg:GetNext()
		end
		if tc:IsRelateToEffect(e) and not tc:IsPosition(POS_FACEUP_ATTACK) then
		   Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
	end
end