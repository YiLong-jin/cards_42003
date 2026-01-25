--奈叶 Magia Clash fin! 
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877895,9877897,9878079)
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
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(cm.acttg)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
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

function cm.acttg(e,c)
	return aux.IsCodeListed(c,9878079)
end

function cm.tgtfilter(c)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877897) or aux.IsCodeListed(c,9878079)) and c:IsFaceup() and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,0x30,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
end

function cm.optfilter(c,e,tp)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877897) or aux.IsCodeListed(c,9878079)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0x30,0,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if tc:IsLocation(0x02) then
			Duel.ConfirmCards(1-tp,tc)
			if Duel.IsExistingMatchingCard(cm.optfilter,tp,0x02,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.optfilter,tp,0x02,0,1,1,nil,e,tp)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function cm.tgsfilter(c,e,tp)
	return c:IsCode(9878079) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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