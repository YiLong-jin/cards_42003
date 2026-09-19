--异兽灭亡作战
function c9877370.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9877370,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9877370)
	e1:SetTarget(c9877370.actg1) 
	e1:SetOperation(c9877370.acop1) 
	c:RegisterEffect(e1) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9877370,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,1877370) 
	e1:SetCost(c9877370.accost2)
	e1:SetTarget(c9877370.actg2) 
	e1:SetOperation(c9877370.acop2) 
	c:RegisterEffect(e1) 
end
function c9877370.spfil1(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xaf5f,0xbeff)   
end 
function c9877370.desfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0x27e4) and Duel.GetMZoneCount(tp,c)>0 
end 
function c9877370.actg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c9877370.desfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c9877370.spfil1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c9877370.desfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c9877370.acop1(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9877370.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then 
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c9877370.spfil1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 
function c9877370.accost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsDestructable() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsDestructable() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil) 
	Duel.Destroy(g,REASON_COST) 
end 
function c9877370.spfil2(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x27e4)   
end 
function c9877370.actg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c9877370.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c9877370.acop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c9877370.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 





