--魔力增幅
local s,id,o=GetID()
function s.initial_effect(c)
		--Activate
	local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,99971000)
	e2:SetTarget(c99971000.target)
	e2:SetOperation(c99971000.activate)
	c:RegisterEffect(e2)
end
function c99971000.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971000))
end
function c99971000.filter1(c,codee)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(codee)
end
function c99971000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971000.filter,tp,0x3f,0x3f,1,nil) and Duel.IsPlayerCanDraw(tp,1)  end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99971000.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971000.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local codee=tc:GetCode()
	local flag=3
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971000.filter1,tp,0x3f,0x3f,1,nil,codee) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end