--疾风 Magia Clash! 
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877895,9877897,m)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m*10)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
end

function cm.tgsfilter(c)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877897) or aux.IsCodeListed(c,m)) and c:IsAbleToHand()
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x30,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x30,0,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		if tc:IsFacedown() then e:SetLabel(1) end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if tc:IsLocation(0x02) or e:GetLabel()==1 then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(0x2)
end

function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end