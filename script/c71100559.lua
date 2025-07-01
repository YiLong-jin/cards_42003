--机魂的归树
function c71100559.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71100559+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(c71100559.target)
	e1:SetOperation(c71100559.activate) 
	c:RegisterEffect(e1)
end  
function c71100559.ckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0xaa)  
end 
function c71100559.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xaa)  
end 
function c71100559.espfil(c,e,tp)
	if not (c:IsSetCard(0xaa) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end 
	if c:IsLocation(LOCATION_EXTRA) then  
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
	else 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end 
end 
function c71100559.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c71100559.ckfil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local b1=g:GetClassCount(Card.GetCode)>=2 and Duel.IsExistingMatchingCard(c71100559.thfil,tp,LOCATION_DECK,0,1,nil)
	local b3=g:GetClassCount(Card.GetCode)>=6 and Duel.IsExistingMatchingCard(c71100559.espfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) 
	local b2=g:GetClassCount(Card.GetCode)>=4 and Duel.IsPlayerCanDraw(tp,2) 
	if chk==0 then return b1 or b2 or b3 end 
	e:SetCategory(0)  
	local Category=0 
	if b1 then 
		Category=Category+CATEGORY_TOHAND 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end 
	if b3 then 
		Category=Category+CATEGORY_SPECIAL_SUMMON  
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
	end 
	if b2 then 
		Category=Category+CATEGORY_DRAW 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2) 
	end  
	e:SetCategory(Category)
end
function c71100559.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c71100559.ckfil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local b1=g:GetClassCount(Card.GetCode)>=2 and Duel.IsExistingMatchingCard(c71100559.thfil,tp,LOCATION_DECK,0,1,nil)
	local b3=g:GetClassCount(Card.GetCode)>=6 and Duel.IsExistingMatchingCard(c71100559.espfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) 
	local b2=g:GetClassCount(Card.GetCode)>=4 and Duel.IsPlayerCanDraw(tp,2) 
	if b1 then 
		local sg=Duel.SelectMatchingCard(tp,c71100559.thfil,tp,LOCATION_DECK,0,1,1,nil)  
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
	if b3 then 
		local sc=Duel.SelectMatchingCard(tp,c71100559.espfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP) 
	end 
	if b2 then 
		Duel.Draw(tp,2,REASON_EFFECT) 
	end  
end




