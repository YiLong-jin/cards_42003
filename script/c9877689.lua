--来自“过去”的魔术师
function c9877689.initial_effect(c)
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,9877689) 
	e1:SetTarget(c9877689.sptg1) 
	e1:SetOperation(c9877689.spop1) 
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)


	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877689,0))
	e11:SetCategory(CATEGORY_TOGRAVE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,1877689)
	e11:SetCost(c9877689.negcost)
	e11:SetTarget(c9877689.tgtg)
	e11:SetOperation(c9877689.tgop)
	c:RegisterEffect(e11)
end
function c9877689.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec)
end 
function c9877689.sptg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9877689.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end 
function c9877689.spop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877689.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end


function c9877689.tgfilter(c)
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end
function c9877689.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9877689.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877689.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9877689.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9877689.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(9877689,0)) then
				Duel.PayLPCost(tp,500)
				local e11=Effect.CreateEffect(e:GetHandler())
				e11:SetDescription(aux.Stringid(9877689,2))
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_ADD_CODE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e11:SetValue(9873030)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e11)
				local e12=Effect.CreateEffect(e:GetHandler())
				e12:SetType(EFFECT_TYPE_FIELD)
				e12:SetCode(EFFECT_UPDATE_ATTACK)
				e12:SetRange(LOCATION_MZONE)
				e12:SetTargetRange(LOCATION_MZONE,0)
				e12:SetTarget(c9877689.tg)
				e12:SetValue(500)
				e12:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e12)
				local e13=e12:Clone()
				e13:SetCode(EFFECT_UPDATE_DEFENSE)
				c:RegisterEffect(e13)
	   end
	
	end
end  


function c9877689.tg(e,c)  
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end