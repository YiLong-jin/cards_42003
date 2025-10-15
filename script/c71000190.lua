--急袭猛禽诱捕战术 2024/10/03 12:17:01 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
	--return 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+ofs)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(this.cost)
	e2:SetTarget(this.rdtg)
	e2:SetOperation(this.rdop)
	c:RegisterEffect(e2)
end
function this.matfilter(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function this.spfilter(c,e,tp)
	return c:IsSetCard(0xba) and c:IsRankBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(this.matfilter,tp,LOCATION_DECK,0,nil)
	local xyzg=Duel.GetMatchingGroup(this.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return mg:GetClassCount(Card.GetCode)>1 and #xyzg>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,this.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(this.matfilter,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)<2 then return end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if #mg>0 then
			Duel.Overlay(sc,mg)
		end
	end
end
function this.rmfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function this.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(this.rmfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local mct=Duel.GetMatchingGroup(this.tdf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil):FilterCount(Card.IsCanBeEffectTarget,nil,e)
	local ct=0
	local min=1
	while true do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local sg=Duel.SelectMatchingCard(tp,this.rmfilter,tp,LOCATION_MZONE,0,min,1,nil,tp)
		if #sg==0 then break end
		sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
		ct=ct+1
		if mct<=ct then break end
		min=0
	end
	e:SetLabel(100,ct)
end
function this.tdf(c)
	return c:IsSetCard(0xba) and c:IsAbleToDeck() and not c:IsCode(id)
end 
function this.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check,ct=e:GetLabel()
	if chkc then return this.tdf(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) end
	if chk==0 then
		if check~=100 then return false end
		e:SetLabel(0,ct)
		return Duel.IsExistingTarget(this.tdf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,this.tdf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function this.rdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
