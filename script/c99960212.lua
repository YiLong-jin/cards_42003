--七曜大贤者 帕秋莉诺蕾姬
local s,id,o=GetID()
function s.initial_effect(c)
		--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(0x2f)
	--c:RegisterEffect(e2)
	
		--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99960212,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCondition(c99960212.condition)
	e1:SetTarget(c99960212.target)
	e1:SetOperation(c99960212.activate1)
	c:RegisterEffect(e1)
end
c99960212.Savior_Koumakan = true
c99960212.Savior_Paqi = true



function c99960212.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c99960212.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=true
	local b2=true
	local b3=true
	local b4=true
	local b5=true
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(99960290,0),1},
		{b2,aux.Stringid(99960300,0),2},
		{b4,aux.Stringid(99960320,0),4},
		{b5,aux.Stringid(99960330,0),5},
		{b3,aux.Stringid(99960310,0),3})
	e:SetLabel(op)
end
function c99960212.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
	Duel.Hint(24,0,aux.Stringid(99960290,0))
	Duel.RegisterFlagEffect(tp,99960290,0,0,0)
	elseif op==2 then
	Duel.RegisterFlagEffect(tp,99960300,0,0,0)
	Duel.Hint(24,0,aux.Stringid(99960300,0))
	elseif op==3 then
	Duel.RegisterFlagEffect(tp,99960310,0,0,0)
	Duel.Hint(24,0,aux.Stringid(99960310,0))
	elseif op==4 then
	Duel.RegisterFlagEffect(tp,99960320,0,0,0)
	Duel.Hint(24,0,aux.Stringid(99960320,0))
	elseif op==5 then
	Duel.RegisterFlagEffect(tp,99960330,0,0,0)
	Duel.Hint(24,0,aux.Stringid(99960330,0))
	end
end
