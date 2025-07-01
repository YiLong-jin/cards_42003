--九天灾域 山中列车
local m=99930090
local cm=_G["c"..m]
function cm.initial_effect(c)
	--code

	--change name
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e15:SetCode(EFFECT_ADD_CODE)
	e15:SetRange(LOCATION_SZONE)
	e15:SetValue(50913601)
	c:RegisterEffect(e15)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

--  local e2=Effect.CreateEffect(c


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(99930090)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)




end
function cm.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsCode(99930040)
end



function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end






















function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x366a) and c:IsAbleToDeck() and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,99930090)==0 and Duel.SelectYesNo(tp,aux.Stringid(99930090,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,3,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,99930090,RESET_PHASE+PHASE_END,0,1)
	end
end