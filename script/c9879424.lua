--一番合戦初命·气焰
function c9879424.initial_effect(c)
	aux.AddCodeList(c,9879421)
	aux.EnableChangeCode(c,9879421,LOCATION_ONFIELD+LOCATION_HAND)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879424,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9879424)
	e1:SetCondition(c9879424.spcon)
	e1:SetTarget(c9879424.sptg)
	e1:SetOperation(c9879424.spop)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879424,0))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetCountLimit(1,1878610)
	e11:SetCost(c9879424.thcost)
	e11:SetTarget(c9879424.thtg)
	e11:SetOperation(c9879424.thop)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e12)
end
function c9879424.cfilter(c)
	return  c:GetControler()~=c:GetOwner()
end
function c9879424.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879424.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c9879424.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879424.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c9879424.thfilter(c)
	return aux.IsCodeListed(c,9879421) and c:IsAbleToHand()
end
function c9879424.costfilter(c)
	return c:GetControler()~=c:GetOwner() and c:IsDiscardable()
end
function c9879424.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879424.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c9879424.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9879424.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879424.thfilter,tp,LOCATION_DECK,0,1,nil)and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879424.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879424.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g)~=0 then
		local g1=Duel.GetDecktopGroup(1-tp,1)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end 
end
