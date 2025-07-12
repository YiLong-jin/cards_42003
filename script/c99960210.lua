--私立魔法图书馆 帕秋莉诺蕾姬
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,7)
		--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c99960210.acop)
	c:RegisterEffect(e1)
		--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99960210,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c99960210.drcost)
	e2:SetOperation(c99960210.drop)
	c:RegisterEffect(e2)
		--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99960210,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c99960210.thcost)
	e3:SetTarget(c99960210.target)
	e3:SetOperation(c99960210.activate)
	c:RegisterEffect(e3)
end
c99960210.Savior_Koumakan = true
c99960210.Savior_Paqi = true

function c99960210.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
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
function s.activate(e,tp,eg,ep,ev,re,r,rp)
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












function c99960210.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler().Savior_Paqi and re:GetHandler():IsType(TYPE_LINK)  and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c99960210.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,7,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,7,REASON_COST)
end

function c99960210.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99960900,0,0,0)
	Duel.Hint(24,0,aux.Stringid(99960900,0))
end