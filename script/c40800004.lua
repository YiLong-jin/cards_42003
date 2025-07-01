--芝士 光
function c40800004.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,40800000)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40800004)
	e1:SetCost(c40800004.cost)
	e1:SetTarget(c40800004.thtg)
	e1:SetOperation(c40800004.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c40800004.spcon)
	e2:SetTarget(c40800004.sptg2)
	e2:SetOperation(c40800004.spop2)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c40800004.sptg)
	e4:SetOperation(c40800004.spop)
	c:RegisterEffect(e4)
end
c40800004.SetCard_RR_ZS=true 
function c40800004.spfilter2(c,tp)
	return c.SetCard_RR_ZS
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c40800004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c40800004.spfilter2,1,REASON_SPSUMMON,true,e:GetHandler(),tp)
end
function c40800004.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,true,REASON_SPSUMMON):Filter(c40800004.spfilter2,e:GetHandler(),tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c40800004.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c40800004.covfilter(c)
	return c:IsCode(40800000) and c:IsCanOverlay()
end
function c40800004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40800004.covfilter(chkc) end
	if chk==0 then return aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c40800004.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler())
		and Duel.IsExistingTarget(c40800004.covfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c40800004.covfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_GRAVE_ACTION,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40800004.spfilter(c,e,tp,mc)
	return aux.IsCodeListed(c,40800000) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c40800004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c40800004.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			local tg=sg:Filter(Card.IsRelateToEffect,nil,e)
			if tg:GetCount()>0 then
				Duel.Overlay(g:GetFirst(),tg)
			end
		end
	end
end
function c40800004.costfilter(c)
	return c:IsCode(40800000) and (c:IsAbleToGraveAsCost() and c:IsLocation(LOCATION_EXTRA+LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeckOrExtraAsCost())
end
function c40800004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and (Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(40800000) and c:IsAbleToGraveAsCost() end,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsCode(40800000) end,tp,LOCATION_GRAVE,0,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c40800004.costfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_EXTRA+LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end
function c40800004.thfilter(c)
	return c.SetCard_RR_ZS  and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40800004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40800004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40800004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40800004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end