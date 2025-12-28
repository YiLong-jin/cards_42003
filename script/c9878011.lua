--你哪位?
function c9878011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9878011.activate)
	c:RegisterEffect(e1)
end
function c9878011.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9878011.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=0
	if opt==0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(9878011,0),aux.Stringid(9878011,1),aux.Stringid(9878011,2),aux.Stringid(9878011,3),aux.Stringid(9878011,4))+1
	end
	if opt==1 and Duel.GetMatchingGroup(c9878011.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil) then
	local g=Duel.GetMatchingGroup(c9878011.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(9878011,5))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetValue(1000)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
  end
   if opt==2 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) then
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag1=g2:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local ag2=g1:Select(1-tp,1,1,nil)
	Duel.SendtoHand(ag1,tp,REASON_EFFECT)
	Duel.SendtoHand(ag2,1-tp,REASON_EFFECT)
  end
	if opt==3 then
	Duel.Recover(tp,4000,REASON_EFFECT)
	Duel.Recover(1-tp,4000,REASON_EFFECT)
	end
   if opt==4 then
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if h1>0 or h2>0 then Duel.BreakEffect() end
	if h1>0 then
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	if h2>0 then
		Duel.ShuffleHand(1-tp)
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
  end
  if opt==5 then
	Duel.SetLP(tp,0)
	Duel.SetLP(1-tp,0)
  end
end