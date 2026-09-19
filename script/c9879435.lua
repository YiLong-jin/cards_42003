--黎明圣地·宝石月魔狼
function c9879435.initial_effect(c)
	aux.AddCodeList(c,9879431)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1eac),4,2)
	c:EnableReviveLimit() 
	
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9879435,0)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,9879435)
	e1:SetCondition(c9879435.spcon1)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end) 
	e1:SetTarget(c9879435.sptg) 
	e1:SetOperation(c9879435.spop) 
	c:RegisterEffect(e1)   
	local e2=e1:Clone() 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetCondition(c9879435.spcon2) 
	c:RegisterEffect(e2) 
	--change 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879435,1))  
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,9879435+9879435) 
	e3:SetTarget(c9879435.cgtg) 
	e3:SetOperation(c9879435.cgop) 
	c:RegisterEffect(e3) 
end
function c9879435.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,9879431)  
end 
function c9879435.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,9879431) 
end 
function c9879435.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x1eac) or c:IsCode(9879431)) 
end 
function c9879435.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879435.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c9879435.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879435.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c9879435.spfil2(c,e,tp) 
	return  not c:IsCode(9879431) and c:GetLevel()~=4 and c:IsLevelAbove(1)
end 
function c9879435.cgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9879435.spfil2,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,c9879435.spfil2,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c9879435.cgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(9879431)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end 
end  