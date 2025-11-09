--谣言纱奈-原点觉醒
local cm,m=GetID()

cm.Uwasa=true
function c9878774.initial_effect(c)
	aux.AddCodeList(c,9877913)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9878774.ffilter,3,true)

	aux.EnableChangeCode(c,9877913,LOCATION_MZONE+LOCATION_GRAVE)
	

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9878774.efilter)
	c:RegisterEffect(e3)

	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TODECK)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,9878774+EFFECT_COUNT_CODE_OATH)
	e11:SetTarget(c9878774.target)
	e11:SetOperation(c9878774.activate)
	c:RegisterEffect(e11)
end
function c9878774.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,9877913) 
end 
function c9878774.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end


function c9878774.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and aux.IsCodeListed(c,9877913) and c:IsAbleToDeck()
end
function c9878774.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9878774.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9878774.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9878774.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c9878774.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		local sg=Duel.GetMatchingGroup(c9878774.stfilter,tp,LOCATION_DECK,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ct>0 and Duel.IsExistingMatchingCard(c9878774.demfilter,tp,LOCATION_MZONE,0,1,nil)
			and sg:GetClassCount(Card.GetCode)>=ct and ft>=ct
			and Duel.SelectYesNo(tp,aux.Stringid(9878774,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local stg=sg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
			Duel.SSet(tp,stg)
		end
	end
end
function c9878774.demfilter(c)
	return aux.IsCodeListed(c,9877913) and c:IsType(TYPE_LINK) and c:IsLink(4) and c:IsFaceup()
end
function c9878774.stfilter(c)
	return c:GetType()==TYPE_TRAP and not aux.IsCodeListed(c,9877913) and c:IsSSetable()
end
