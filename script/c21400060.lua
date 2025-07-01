--奸奇千化使
function c21400060.initial_effect(c)
	c:SetSPSummonOnce(21400060)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x3210),2,2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400060,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,21400060)
	e1:SetCondition(c21400060.tfcon)
	e1:SetTarget(c21400060.tftg)
	e1:SetOperation(c21400060.tfop)
	c:RegisterEffect(e1)
	--coin 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400056,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11400060)
	--e2:SetCost(c21400060.cncost)
	e2:SetTarget(c21400060.cntg)
	e2:SetOperation(c21400060.cnop)
	c:RegisterEffect(e2)  
end
c21400060.toss_coin=true
function c21400060.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) 
end 
function c21400060.tffilter(c,tp)
	return (c:IsType(TYPE_FIELD) or (c:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) and c:IsSetCard(0x3210) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c21400060.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400060.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c21400060.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c21400060.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc==nil then return end 
	if tc:IsType(TYPE_FIELD) then 
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end 
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c21400060.costfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c21400060.cncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400060.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400060.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c21400060.cntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400060.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c21400060.setfil(c) 
	return c:IsSetCard(0x3210) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end 
function c21400060.spfil(c,e,tp) 
	return c:IsSetCard(0x3210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function c21400060.cnop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.SelectMatchingCard(tp,c21400060.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst() 
	if tc==nil then return end 
	Duel.SendtoGrave(tc,REASON_EFFECT)
	local res=2 
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) then 
		res=Duel.SelectOption(tp,aux.Stringid(21400060,1),aux.Stringid(21400060,2))
	else 
		res=1-Duel.TossCoin(tp,1) 
	end 
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c21400060.setfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c21400060.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end  

