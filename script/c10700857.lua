--槲寄生剑 米斯特汀
function c10700857.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700857,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10700857.rcon)
	e2:SetOperation(c10700857.rop)
	c:RegisterEffect(e2)  
	--double damage  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(10700857,1))  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,10700857)
	e3:SetCost(c10700857.dbcost)  
	e3:SetOperation(c10700857.dbop)  
	c:RegisterEffect(e3)  
end
c10700857.has_text_type=TYPE_DUAL
function c10700857.tgfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToDeck()
end
function c10700857.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():GetOverlayCount()>=ev-1
		and Duel.IsExistingMatchingCard(c10700857.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
end
function c10700857.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700857.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,99,nil,tp)
	return Duel.SendtoGrave(g,REASON_COST)
end
function c10700857.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c10700857.costfilter2(c)
	return c:IsType(TYPE_DUAL) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToRemoveAsCost()
end
function c10700857.dbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10700857.costfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=5 and Duel.IsExistingMatchingCard(c10700857.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,5,5)
	aux.GCheckAdditional=nil
	if Duel.Remove(rg,POS_FACEUP,REASON_COST)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c10700857.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(tg,REASON_COST)
	end
end
function c10700857.dbop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c10700857.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,10700857,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(DOUBLE_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end  
function c10700857.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,10700857)==0 or bit.band(r,REASON_EFFECT)==0 then return val end
	Duel.ResetFlagEffect(tp,10700857)
	return val*2
end