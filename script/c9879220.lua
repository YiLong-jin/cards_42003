--核心列车 超越空间
c9879220.hxlc=true
function c9879220.initial_effect(c)
	c:SetUniqueOnField(1,0,9879220)


	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9879220)
	e2:SetTarget(c9879220.sptg)
	e2:SetOperation(c9879220.spop)
	c:RegisterEffect(e2)


	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCountLimit(1,1879220) 
	e3:SetTarget(c9879220.dttg) 
	e3:SetOperation(c9879220.dtop) 
	c:RegisterEffect(e3) 
	

end
function c9879220.spfilter(c,e,tp)
	return c.hxlc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879220.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end
function c9879220.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879220.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c9879220.desfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) 
end 
function c9879220.dttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9879220.desfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToHand() end 
	local g=Duel.SelectTarget(tp,c9879220.desfil,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c9879220.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,c) 
	end 
end 