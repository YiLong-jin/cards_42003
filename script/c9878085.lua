--菲特 Magia Clash fin!
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877895,9877897,9878084)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetCondition(cm.lmcon)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--act qp in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.eqcon)
	e1:SetValue(cm.actlimit)
	c:RegisterEffect(e1)
	--indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e8:SetValue(cm.indct)
	c:RegisterEffect(e8)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.atcon)
	e2:SetTarget(cm.attg)
	e2:SetOperation(cm.atop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end

function cm.lmcon(e)
	return e:GetHandler():IsLocation(0x40)
end

function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

function cm.actlimit(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end

function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end

function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable()
end

function cm.costafilter(c)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877897) or aux.IsCodeListed(c,9878084)) and c:IsAbleToHand()
end

function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costafilter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.costafilter,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.ChainAttack()
	end
end

function cm.tgsfilter(c,e,tp)
	return c:IsCode(9878084) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x10,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x10,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end