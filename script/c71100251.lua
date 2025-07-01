--革命组件:防空机炮
local m=71100251
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSetCard(0x7da) and c:IsAbleToGraveAsCost()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,c)
	if chk==0 then return #cg>0 and c:IsSetCard(0x7da) and c:IsAbleToGraveAsCost() and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cog=cg:Select(tp,1,1,nil)
	cog:AddCard(c)
	Duel.SendtoGrave(cog,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	Duel.RegisterEffect(e1,tp)
	Duel.Draw(tp,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if #g>0 then 
		Duel.ConfirmCards(1-tp,g)
		if not g:IsExists(Card.IsSetCard,1,nil,0x7da) then 
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end