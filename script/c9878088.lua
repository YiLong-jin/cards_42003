--疾风 Magia Clash fin!
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877895,9877897,9878084,9878087)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetCondition(cm.lmcon)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.chainop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
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

function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end

function cm.chainlm(e,rp,tp)
	return tp==rp
end

function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(0x2) and Duel.IsChainNegatable(ev)
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end

function cm.opdfilter(c)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877897) or aux.IsCodeListed(c,9878084) or aux.IsCodeListed(c,9878087)) and c:IsFaceup() and c:IsAbleToHand()
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(cm.opdfilter,tp,0x30,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local tc=Duel.SelectMatchingCard(tp,cm.opdfilter,tp,0x30,0,1,1,nil):GetFirst()
			if tc then
				Duel.HintSelection(Group.FromCards(tc))
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				if tc:IsLocation(0x02) then
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		end
	end
end

function cm.tgsfilter(c,e,tp)
	return c:IsCode(9878087) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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