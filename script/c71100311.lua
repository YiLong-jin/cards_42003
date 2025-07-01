--秘源异术 黯影突袭
function c71100311.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c71100311.actg) 
	e1:SetOperation(c71100311.acop) 
	c:RegisterEffect(e1)
end
function c71100311.dsfil(c) 
	return c:IsCanChangePosition() and c:IsFaceup() and not c:IsLocation(LOCATION_PZONE) and not c:IsType(TYPE_TOKEN)
end 
function c71100311.ckfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7de) 
end 
function c71100311.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingMatchingCard(c71100311.ckfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c71100311.dsfil,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,c71100311.dsfil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c71100311.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) 
	Duel.Destroy(tc,REASON_EFFECT)
	end 
	c:CancelToGrave() 
	Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
end 






