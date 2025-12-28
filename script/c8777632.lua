--「猩红相映的红魔之馆」
function c8777632.initial_effect(c)
	 aux.AddCodeList(c,8777633) 


	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1ea1))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)


	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(8777632,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,8777632) 
	e3:SetTarget(c8777632.sptg) 
	e3:SetOperation(c8777632.spop) 
	c:RegisterEffect(e3) 

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(8777632,1))
	e12:SetCategory(CATEGORY_TOGRAVE)
	e12:SetType(EFFECT_TYPE_IGNITION) 
	e12:SetRange(LOCATION_SZONE) 
	e12:SetCountLimit(1,8777632)
	e12:SetCost(c8777632.negcost)
	e12:SetTarget(c8777632.thtg)
	e12:SetOperation(c8777632.thop)
	c:RegisterEffect(e12)


end

function c8777632.spfil(c,e,tp) 
	return c:IsSetCard(0x1ea1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function c8777632.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c8777632.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)   
end 
function c8777632.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c8777632.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 


function c8777632.thfilter(c)
	return (c:IsSetCard(0x1ea1) or aux.IsCodeListed(c,8777633))  and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()  
end
function c8777632.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c8777632.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777632.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c8777632.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c8777632.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end