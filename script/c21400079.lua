--铸造恐虐的京观
function c21400079.initial_effect(c)   
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,21400079)
	e1:SetTarget(c21400079.ddrtg)
	e1:SetOperation(c21400079.ddrop)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,21400079)
	e2:SetTarget(c21400079.settg)
	e2:SetOperation(c21400079.setop)
	c:RegisterEffect(e2)
end 
function c21400079.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6210)
end
function c21400079.ddrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21400079.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21400079.desfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21400079.desfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c21400079.ddrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,2) then
		Duel.Draw(tp,2,REASON_EFFECT) 
	end 
end 
function c21400079.setfilter(c)
	return c:IsSetCard(0x6210) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c21400079.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400079.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21400079.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21400079.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end





