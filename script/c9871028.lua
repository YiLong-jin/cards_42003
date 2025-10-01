--薇特莉斯甜点工坊-莉姬
function c9871028.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x7ef),5,2)
	c:EnableReviveLimit() 

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9871028,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9871028)
	e1:SetCondition(c9871028.spcon)
	e1:SetTarget(c9871028.sptg)
	e1:SetOperation(c9871028.spop)
	c:RegisterEffect(e1) 

	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9871028,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1871028)
	e2:SetCost(c9871028.cost)
	e2:SetTarget(c9871028.target)
	e2:SetOperation(c9871028.activate)
	c:RegisterEffect(e2)
end
function c9871028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9871028.spfilter(c,e,tp)
	return c:IsSetCard(0x17e4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9871028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9871028.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9871028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9871028.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end 
end  

function c9871028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9871028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_SZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_SZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end
function c9871028.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end


