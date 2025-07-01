--盟军·先锋武装战艇机
function c71100166.initial_effect(c)
			--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,12,3)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100166,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,71100166)
	e1:SetTarget(c71100166.target)
	e1:SetOperation(c71100166.operation)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c71100166.efilter)
	c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71100166,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c71100166.atcon)
	e3:SetCost(c71100166.atcost)
	e3:SetOperation(c71100166.atop)
	c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,71100166)
	e4:SetCost(c71100166.spcost)
	e4:SetTarget(c71100166.sptg)
	e4:SetOperation(c71100166.spop)
	c:RegisterEffect(e4)
end
function c71100166.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7d9) and c:IsType(TYPE_XYZ) and not c:IsCode(71100166)
end
function c71100166.filter(c,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsType(TYPE_TOKEN)
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c71100166.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71100166.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c71100166.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71100166.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c71100166.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c71100166.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c71100166.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c
end
function c71100166.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71100166.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c71100166.cfilter(c,tp)
	return c:IsSetCard(0x7d9)and Duel.GetMZoneCount(tp,c)>0
end
function c71100166.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c71100166.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c71100166.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c71100166.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71100166.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end