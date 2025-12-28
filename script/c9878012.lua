--不带这么玩的！！！
function c9878012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9878012.condition)
	e1:SetOperation(c9878012.activate)
	c:RegisterEffect(e1)
end
function c9878012.condition(e,tp,eg,ep,ev,re,r,rp)
   return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end 
function c9878012.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=0
	if opt==0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(9878012,0),aux.Stringid(9878012,1))+1
	end
	if opt==1 then
	Duel.Recover(tp,4000,REASON_EFFECT)
	Duel.Draw(tp,2,REASON_EFFECT)
	end
	if opt==2 then
	Duel.Damage(tp,2000,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end