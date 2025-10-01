--薇特莉斯甜点工坊-熊熊种子巧克力
function c9871027.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x17e4),4,2)
	c:EnableReviveLimit() 

	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9871027,0)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)   
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,9871027)  
	e1:SetCost(c9871027.spcost)
	e1:SetTarget(c9871027.sptg) 
	e1:SetOperation(c9871027.spop) 
	c:RegisterEffect(e1) 
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9871027,1))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1000)
	e3:SetCondition(c9871027.gfcon)
	c:RegisterEffect(e3)
end
function c9871027.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c9871027.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x7ef) and c:IsType(TYPE_XYZ)  
end 
function c9871027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsExistingMatchingCard(c9871027.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c9871027.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9871027.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end

function c9871027.gfcon(e)
	return e:GetHandler():IsSetCard(0x7ef)
end  