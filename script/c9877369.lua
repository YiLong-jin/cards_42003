--危险等级S-进化甲壳兽（死亡）
function c9877369.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9877369,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_DESTROYED)  
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e1:SetCountLimit(1,9877369)
	e1:SetCondition(c9877369.ddcon) 
	e1:SetTarget(c9877369.ddtg)  
	e1:SetOperation(c9877369.ddop) 
	c:RegisterEffect(e1)	 
	--to grave and des 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877369,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,9877369)   
	e2:SetCondition(function(e)  
	local re=e:GetHandler():GetReasonEffect()
	return re and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsReason(REASON_EFFECT) end)
	e2:SetTarget(c9877369.tgdtg) 
	e2:SetOperation(c9877369.tgdop) 
	c:RegisterEffect(e2) 
end
function c9877369.ddckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) 
end 
function c9877369.ddcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c9877369.ddckfil,1,nil,tp)  
end 
function c9877369.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877369.ddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9877369.tspfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x27e4) or c:IsRace(RACE_INSECT)) and not c:IsCode(9877369)  
end 
function c9877369.tgdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877369.tspfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
end 
function c9877369.tgdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877369.tspfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		if x>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(9877369,0)) then 
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,TYPE_MONSTER) 
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end  
end 




