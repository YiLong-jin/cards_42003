--幻想乡 魔界
function c99960020.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99960020+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c99960020.activate)
	c:RegisterEffect(e1)
	
		local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c99960020.tftg)
	e4:SetCost(c99960020.lvcost)
	e4:SetOperation(c99960020.lvop)
	c:RegisterEffect(e4)
	
end
c99960020.Savior_mojie=true

function c99960020.costfilter(c,lv)
	return c.Savior_mojie and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99960020.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99960020.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99960020.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99960020.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99960020.sumfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c99960020.lvop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=Duel.SelectMatchingCard(tp,c99960020.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Summon(tp,sg:GetFirst(),true,nil)
	end
end
function c99960020.sumfilter(c)
	return c:IsSummonable(true,nil) and c.Savior_mojie
end



function c99960020.thfilter(c)
	return c.Savior_mojie and c:IsAbleToHand()
end
function c99960020.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99960020.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99960020,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end