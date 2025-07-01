--追迹日落以西
local s,id,o=GetID()
function s.initial_effect(c)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	e1	:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id+o)
	e4:SetCondition(s.bacon)
	e4:SetTarget(s.batg)
	e4:SetOperation(s.baop)
	c:RegisterEffect(e4)
---------------------------------------------------------------------------------------------------------------------------------------------------------------	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(s.atktg)
	e5:SetValue(500)
	c:RegisterEffect(e5)
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
function s.filter(c)
	return c:IsSetCard(0x7bc) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
function s.bacon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if not ac:IsControler(tp) then ac,bc=bc,ac end
	e:SetLabelObject(bc)
	return ac:IsFaceup() and ac:IsControler(tp) and ac:IsSetCard(0x7bc) and bc:IsControler(1-tp)
end
function s.batg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if not bc then return false end
	if chk==0 then return bc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,bc,1,0,0)
end
function s.baop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
function s.atktg(e,c)
	return c:IsSetCard(0x7bc)
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0x7bc) and c:IsType(TYPE_MONSTER)
		and (c:IsPreviousLocation(LOCATION_GRAVE)
			or (c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x7bc)))
end