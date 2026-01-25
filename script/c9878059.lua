--鹤乃·菲莉希亚 奇迹星辰
function c9878059.initial_effect(c)
	aux.AddCodeList(c,9877877,9877951)
	aux.AddXyzProcedure(c,nil,4,3)
	aux.AddXyzProcedureLevelFree(c,c9878059.mfilter,nil,2,2)
	c:EnableReviveLimit()

	 aux.EnableChangeCode(c,9877877,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9878059,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9878059)
	e1:SetCondition(c9878059.descon)
	e1:SetTarget(c9878059.destg)
	e1:SetOperation(c9878059.desop)
	c:RegisterEffect(e1) 

	local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(9878059,1))
	e14:SetCategory(CATEGORY_TOHAND) 
	e14:SetType(EFFECT_TYPE_QUICK_O) 
	e14:SetCode(EVENT_FREE_CHAIN) 
	e14:SetRange(LOCATION_MZONE)
	e14:SetHintTiming(0,TIMING_END_PHASE)
	e14:SetCountLimit(1,9878059)
	e14:SetCost(c9878059.thcost)
	e14:SetTarget(c9878059.tgtg) 
	e14:SetOperation(c9878059.tgop) 
	c:RegisterEffect(e14) 
end
function c9878059.mfilter(c)
	return (aux.IsCodeListed(c,9877951) or aux.IsCodeListed(c,9877877)) and c:IsXyzType(TYPE_MONSTER)
end 

function c9878059.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9878059.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9878059.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   if Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(9878059,0)) then
		 e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		 Duel.Draw(tp,1,REASON_EFFECT)
	   end
	end
end 


function c9878059.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9878059.tgfil(c) 
	return c:IsAbleToHand() and (aux.IsCodeListed(c,9877877) or aux.IsCodeListed(c,9877951)) and c:IsFaceup()
end 
function c9878059.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878059.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end 
function c9878059.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9878059.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
	   Duel.SendtoHand(sg,nil,REASON_EFFECT)  
	   Duel.ConfirmCards(1-tp,sg)
	end 
end 