--属于我们的魔法
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9878079)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
end

function cm.conefilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9878079)
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conefilter,tp,0x04,0,1,nil)
end

function cm.tgafilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end

function cm.tgafilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end

function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgafilter,tp,0,0x04,1,nil) and Duel.IsExistingMatchingCard(cm.tgafilter2,tp,0x04,0,1,nil) end
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g,n=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,0x04,nil),Duel.GetMatchingGroupCount(cm.tgafilter2,tp,0x04,0,nil)*200
	if #g>0 and n>0 then
		local c=e:GetHandler()
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-n)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		local ng=g:Filter(Card.IsAttack,nil,0)
		if #ng>0 then
			for tc in aux.Next(ng) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
		end
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsRelateToChain() then
			c:CancelToGrave()
			if c:IsAbleToDeck() then
				Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			else
				c:CancelToGrave(false)
			end
		end
	end
end