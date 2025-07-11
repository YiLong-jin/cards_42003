--七曜融合贤者
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99960215.target1)
	e1:SetOperation(c99960215.activate1)
	--c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c99960215.target)
	e3:SetOperation(c99960215.activate)
	c:RegisterEffect(e3)
	
end
c99960215.Savior_Paqi = true


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




function c99960215.filter(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c99960215.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99960215.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99960215.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99960215.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
