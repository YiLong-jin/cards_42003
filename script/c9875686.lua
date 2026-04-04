--协证曲的终之歌
function c9875686.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2ea7),7,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(function(e,c)
	return c:IsSetCard(0x2ea7) end)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--set and des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9875686) 
	e2:SetTarget(c9875686.sdtg) 
	e2:SetOperation(c9875686.sdop) 
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(9875686,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,1875686) 
	e3:SetTarget(c9875686.sptg) 
	e3:SetOperation(c9875686.spop) 
	c:RegisterEffect(e3) 
end 
function c9875686.setfil(c) 
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x2ea7)   
end 
function c9875686.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875686.setfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
	local g=Duel.SelectTarget(tp,c9875686.setfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
end 
function c9875686.sdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(9875667) end,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875686,1)) then
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,2,nil) 
		Duel.Destroy(dg,REASON_EFFECT) 
	end   
end 
function c9875686.sckfil(c,tp) 
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0x2ea7) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)   
end 
function c9875686.spfil(c,e,tp) 
	return c:IsSetCard(0x2ea7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c9875686.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9875686.sckfil,1,nil,tp) and Duel.IsExistingMatchingCard(c9875686.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c9875686.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9875686.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(9875669) end,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,3,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875686,0)) then 
			Duel.BreakEffect() 
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,3,3,nil) 
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT) 
		end  
	end 
end 





