--黑骑士小队-即灭
function c9877633.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,99,c9877633.lcheck)
	c:EnableReviveLimit()  

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PAY_LPCOST) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9877633)
	e2:SetTarget(c9877633.ddtg)  
	e2:SetOperation(c9877633.ddop) 
	c:RegisterEffect(e2) 
end
function c9877633.lcheck(g,lc)
	return g:IsExists(c9877633.mzfilter,1,nil)
end
function c9877633.mzfilter(c)
	return c:IsLinkSetCard(0x17ec)
end


function c9877633.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec)
end
function c9877633.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9877633.tgfil1,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end  
function c9877633.ddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877633.tgfil1,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,sg)~=0  and Duel.CheckLPCost(tp,2000) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9877633,0))  then 
		Duel.PayLPCost(tp,2000)
		Duel.Draw(tp,1,REASON_EFFECT) 
		end
	end
end