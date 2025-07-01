--革命组件:集束弹巢
local m=71100252
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3019642,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSetCard(0x7da) and c:IsAbleToGraveAsCost()
end
function cm.thf(c)
	return c:IsSetCard(0x7da) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,c)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.thf,tp,LOCATION_GRAVE,0,1,nil) and c:IsSetCard(0x7da) and c:IsAbleToGraveAsCost() and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thf,tp,LOCATION_GRAVE,0,1,#cg+1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cog=cg:Select(tp,#g-1,#g-1,nil)
	cog:AddCard(c)
	Duel.SendtoGrave(cog,REASON_COST) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoHand(rg,nil,REASON_EFFECT)~=0 then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end