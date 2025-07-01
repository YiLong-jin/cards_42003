--The Savior of the Collection
local m=99970140
local cm=_G["c"..m]
function cm.initial_effect(c)
	--draw
		--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c99970140.splimit)
	c:RegisterEffect(e4)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99970140,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,99970140)
	e5:SetCondition(c99970140.condition)
	e5:SetCost(c99970140.sumcost)
	e5:SetTarget(c99970140.sumtg)
	e5:SetOperation(c99970140.sumop)
	c:RegisterEffect(e5)	
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970140,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99970141)
	e1:SetTarget(c99970140.tftg)
	e1:SetOperation(c99970140.tfop)
	c:RegisterEffect(e1)


end
function c99970140.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x1661) or se:GetHandler():IsCode(99970140)
end





function c99970140.cfilter(c)
	return (c:IsSetCard(0x1661) and c:IsType(TYPE_SPELL)) and c:IsAbleToHand()
end
function c99970140.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970140.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970140.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970140.cfilter,tp,LOCATION_DECK,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end















function c99970140.cfilter1(c)
	return c:IsFaceup() and (c:IsSetCard(0x671) or c:IsSetCard(0x676) or c:IsSetCard(0x66c) or c:IsSetCard(0x669))
end
function c99970140.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99970140.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99970140.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c99970140.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local a,b=Duel.AnnounceNumber(tp,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)
	e:SetLabel(a)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99970140.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	local tc=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	if tc>=1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-e:GetLabel()*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		end
	end
end

