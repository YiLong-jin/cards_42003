--天启饥荒·不毛之地
local m=99950310
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,99)
	c:EnableReviveLimit()

	--tograve
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,1))
	e21:SetCategory(CATEGORY_DECKDES)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1,99950310)
	e21:SetCondition(cm.condition2)
	e21:SetCost(cm.cost2)
	e21:SetTarget(cm.target2)
	e21:SetOperation(cm.operation2)
	c:RegisterEffect(e21)

	--check overlay group when destroy
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_DESTROY_REPLACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(cm.reptg)
	e0:SetValue(cm.repval)
	c:RegisterEffect(e0)

	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtarg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	--disable and destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(cm.tgcon)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	--decrease atk/def

	--to wife
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROY)
	e3:SetLabelObject(e0)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)


end
function cm.adcon(e)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>=1
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0x66c)>=2
end
function cm.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.tgcon(e,tp)
	local eo=e:GetHandler():GetOverlayGroup()
	local turn=Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	local mph=Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
	local ct=eo:FilterCount(Card.IsSetCard,nil,0x66c)>=4
	return rp==1-tp and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function cm.atkcon(e)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>=4
end
function cm.atkval(e,c)
	local dc=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local wc=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local dif=0
	if dc~=wc then
		dif=(dc>wc) and (dc-wc) or (wc-dc)
	end
	return dif*-1000
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local e0 = e:GetLabelObject()
	local g = e0:GetLabelObject()
	if chk==0 then return g and g:GetCount()>=5 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local e0 = e:GetLabelObject()
	local g = e0:GetLabelObject()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local perg = e:GetLabelObject()
	if perg then 
		perg:DeleteGroup() 
	end
	local nowg = e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0x66c)
	nowg:KeepAlive()
	e:SetLabelObject(nowg)
	return false 
end
function cm.repval(e,c)
	return false
end




















function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.filter2(c)
	return c:IsSetCard(0x66c) and c:IsAbleToGrave()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local cd1=Duel.GetOverlayCount(tp,1,0)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local cg=Duel.RemoveOverlayCard(tp,1,0,cd1,cd1,REASON_COST)
	local cd2=Duel.GetOverlayCount(tp,1,0)
	e:SetLabel(cd1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,cd1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end