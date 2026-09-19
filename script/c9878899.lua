--叛逆者的龙神-鬼神玉笠
function c9878899.initial_effect(c)
	

	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9878899)
	e1:SetCondition(c9878899.spcon1)
	e1:SetTarget(c9878899.sptg1)
	e1:SetOperation(c9878899.spop1)
	c:RegisterEffect(e1) 

	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9878899,1))
	e13:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetRange(LOCATION_SZONE)
	e13:SetCountLimit(1,1878899)
	e13:SetCondition(c9878899.thcon)
	e13:SetTarget(c9878899.thtg)
	e13:SetOperation(c9878899.thop)
	c:RegisterEffect(e13)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9878899,0))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCountLimit(1,2878899) 
	e11:SetTarget(c9878899.sptg)
	e11:SetOperation(c9878899.spop)
	c:RegisterEffect(e11)
end

function c9878899.f(c)
	return c:IsFaceup() and  c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end
function c9878899.spcon1(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9878899.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9878899.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9878899.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function c9878899.spfil(c,e,tp)
	return c:IsSetCard(0x17ec) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9878899.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9878899.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9878899.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9878899.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9878899,2)) then 
		Duel.BreakEffect()
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT) 
	end
end


function c9878899.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c9878899.thfilter(c)
	return c:IsSetCard(0x17ec) and c:IsAbleToHand()
end
function c9878899.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878899.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9878899.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878899.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end