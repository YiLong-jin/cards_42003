--墟界天使 追循森角
local m=30553215
local cm=_G["c"..m]
function cm.initial_effect(c)
		 --link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit() 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to deck  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TODECK)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+100)  
	e2:SetTarget(cm.tdtg)  
	e2:SetOperation(cm.tdop)  
	c:RegisterEffect(e2)  
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x302)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.spfilter1(c,e,tp)
	return c:GetLevel()>0 and c:IsSetCard(0x302) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.spfilter2,tp,LOCATION_GRAVE,0,1,c,c:GetLevel(),e,tp)
end
function cm.spfilter2(c,lv,e,tp)
	return c:IsLevel(lv) and c:IsSetCard(0x302) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,cm.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc1=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectTarget(tp,cm.spfilter2,tp,LOCATION_GRAVE,0,1,1,tc1,tc1:GetLevel(),e,tp)
		g:Merge(g2)
		local tc=g:GetFirst()
		while tc do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e0=Effect.CreateEffect(c)  
				e0:SetType(EFFECT_TYPE_SINGLE)  
				e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
				e0:SetReset(RESET_EVENT+RESETS_REDIRECT)  
				e0:SetValue(LOCATION_REMOVED)  
				tc:RegisterEffect(e0,true) 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.thfilter(c)  
	return c:IsSetCard(0x302) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) 
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
end  
function cm.sfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end--or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(cm.sfilter,1,nil,tp) then Duel.SortDecktop(tp,tp,g:FilterCount(cm.sfilter,nil,tp)) end
end  