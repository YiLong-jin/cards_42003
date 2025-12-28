--双头战龟武装mk2-梅莉
function c9877637.initial_effect(c)
	c:SetSPSummonOnce(9877637)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9877637.matfilter,2,2)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	

	local e11=Effect.CreateEffect(c)  
	e11:SetDescription(aux.Stringid(9877637,1)) 
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_PAY_LPCOST)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCountLimit(1)  
	e11:SetTarget(c9877637.settg)  
	e11:SetOperation(c9877637.setop)  
	c:RegisterEffect(e11)  

end
c9877637.SetCard_AY_ML=true
function c9877637.matfilter(c)
	return c:IsLinkSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end


function c9877637.tgfilter(c)
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9877637.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c9877637.tgfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end  
function c9877637.setop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877637.tgfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g)~=0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877637,0)) then
		Duel.BreakEffect()
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end  