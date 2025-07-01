--团结一致的证明
local m=71000101
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,8,8,cm.lcheck)
	c:EnableReviveLimit()
	--change damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon1)
	e1:SetOperation(cm.regop1)
	c:RegisterEffect(e1)
	--effect gain  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetCondition(cm.regcon)  
	e2:SetOperation(cm.regop)  
	c:RegisterEffect(e2) 
end
function cm.matfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetOriginalCode)==g:GetCount()
end
function cm.regcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetTargetRange(1,0)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gl=c:GetMaterial()
	if gl:FilterCount(aux.FilterBoolFunction(Card.IsOriginalSetCard,0x1034),nil)==gl:GetCount() then
		--todeck
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,0)) 
		e3:SetCategory(CATEGORY_TODECK)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetTarget(cm.tdtg)
		e3:SetOperation(cm.tdop)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if gl:FilterCount(aux.FilterBoolFunction(Card.IsOriginalSetCard,0x56),nil)==gl:GetCount() then
		--equip
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,2)) 
		e4:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
		e4:SetType(EFFECT_TYPE_IGNITION)
		e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e4:SetCountLimit(1)
		e4:SetTarget(cm.eqtg)
		e4:SetOperation(cm.eqop)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	if gl:FilterCount(aux.FilterBoolFunction(Card.IsOriginalSetCard,0x150),nil)==gl:GetCount() then
		--equip
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(m,4)) 
		e5:SetCategory(CATEGORY_NEGATE)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(2)
		e5:SetCondition(cm.negcon)
		e5:SetOperation(cm.negop)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function cm.filter(c)
	return c:IsRace(RACE_INSECT) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	if ft>1 then ft=2 end
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<sg:GetCount() then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,false,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	Duel.EquipComplete()
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(m)==0 and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and rp~=tp and Duel.IsChainDisablable(ev)
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then  
		Duel.Hint(HINT_CARD,0,m)  
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev)
	end  
end 










