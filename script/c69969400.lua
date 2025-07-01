--健全的灵魂
function c69969400.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2,nil,nil,99)
	c:EnableReviveLimit()
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c69969400.matcheck)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c69969400.xcon)
	e2:SetValue(c69969400.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969400,0))
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c69969400.xyzcon)
	e3:SetTarget(c69969400.xyztg)
	e3:SetOperation(c69969400.xyzop)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c69969400.matfilter(c)
	return c:IsXyzType(TYPE_MONSTER) and c:IsAttackAbove(0) and not c:IsAttack(0)
end
function c69969400.mdtfilter(c)
	return c:IsXyzType(TYPE_MONSTER) and c:IsDefenseAbove(0) and not c:IsDefense(0) and not c:IsType(TYPE_LINK)
end
function c69969400.matcheck(e,c)
	local g=c:GetMaterial():Filter(c69969400.matfilter,nil)
	local g2=c:GetMaterial():Filter(c69969400.mdtfilter,nil)
	local atk=g:GetSum(Card.GetBaseAttack)
	local def=g2:GetSum(Card.GetBaseDefense)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e2)
end
--2
function c69969400.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0x69d) and c:IsType(TYPE_XYZ)
end
function c69969400.atkval(e,c)
	return c:GetOverlayCount()*100
end
--2.1
function c69969400.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsStatus(STATUS_OPPO_BATTLE) and tc:IsControler(1-tp) and tc:IsCanOverlay() and tc:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x69d) and c:IsType(TYPE_XYZ)
end
function c69969400.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
end
function c69969400.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end




