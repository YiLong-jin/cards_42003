--九天灾域 机械工厂
local m=99930080
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(99930080)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)

	--change name
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e15:SetCode(EFFECT_ADD_CODE)
	e15:SetRange(LOCATION_SZONE)
	e15:SetValue(28388296)
	c:RegisterEffect(e15)





end
function cm.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsCode(99930030)
end






function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(400)
	Duel.RegisterEffect(e1,tp)
end





















function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x366a) and c:IsAbleToHand() 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,99930080)==0 and Duel.SelectYesNo(tp,aux.Stringid(99930080,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.RegisterFlagEffect(tp,99930080,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end 
end