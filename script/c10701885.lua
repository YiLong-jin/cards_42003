--心园装置-三重舞台
function c10701885.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701885,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10701885)
	e1:SetTarget(c10701885.mattg)
	e1:SetOperation(c10701885.matop)
	c:RegisterEffect(e1) 
	--destory&tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701885,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10701886)
	e2:SetTarget(c10701885.seltg)
	e2:SetOperation(c10701885.selop)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701885,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10701887)
	e3:SetCost(c10701885.spcost)
	e3:SetTarget(c10701885.sptg)
	e3:SetOperation(c10701885.spop)
	c:RegisterEffect(e3) 
end
function c10701885.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c10701885.matfilter2(c)
	return c:IsLevel(1) and c:IsCanOverlay()
end
function c10701885.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10701885.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701885.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c10701885.matfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10701885.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10701885.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10701885.matfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
		if sg and sg:GetCount()>0 then
			Duel.Overlay(tc,sg)
		end
	end
end
function c10701885.desfilter1(c)
	return c:IsLevel(1) and c:IsAttack(0) and c:IsDefense(0)
end
function c10701885.seltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	local b1=Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		or Duel.IsExistingMatchingCard(c10701885.desfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c10701885.selop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)==0 then return end
	local b1=Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		or Duel.IsExistingMatchingCard(c10701885.desfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)	
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(10701885,3),aux.Stringid(10701885,4))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(10701885,3))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(10701885,4))+1
	else return end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,function(c)
			return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) 
				or (c:IsLocation(LOCATION_DECK) and c10701885.desfilter1(c))
		end,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			if g:GetFirst():IsLocation(LOCATION_DECK) then
				Duel.ConfirmCards(1-tp,g)
			end
			Duel.Destroy(g,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c10701885.costfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToDeckOrExtraAsCost()
end
function c10701885.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10701885.costfilter,tp,LOCATION_GRAVE,0,2,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10701885.costfilter,tp,LOCATION_GRAVE,0,2,2,c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10701885.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701885.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end