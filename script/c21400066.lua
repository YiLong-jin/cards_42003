--奸奇魔域·万变迷宫
function c21400066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--coin 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,21400066)
	e1:SetCondition(c21400066.cncon)
	e1:SetTarget(c21400066.cntg)
	e1:SetOperation(c21400066.cnop)
	c:RegisterEffect(e1)
	--thd 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400066)
	e2:SetTarget(c21400066.thdtg)
	e2:SetOperation(c21400066.thdop)
	c:RegisterEffect(e2)
end
c21400066.toss_coin=true 
function c21400066.cncon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x3210) end,tp,LOCATION_MZONE,0,1,nil) and rp==1-tp  
end 
function c21400066.cntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end 
function c21400066.cnop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local res=2 
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) then 
		res=Duel.SelectOption(tp,aux.Stringid(21400065,1),aux.Stringid(21400065,2))
	else 
		res=1-Duel.TossCoin(tp,1) 
	end 
	if res==0 then
		Duel.NegateEffect(ev)
	else 
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil) 
		if dg:GetCount()>0 then 
			Duel.Destroy(dg,REASON_EFFECT)
		end 
	end 
end 
function c21400066.tdhfil(c) 
	return c:IsSetCard(0x3210) and c:IsFaceup() and (c:IsAbleToHand() or c:IsAbleToDeck()) 
end 
function c21400066.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21400066.tdhfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end 
	local g=Duel.SelectTarget(tp,c21400066.tdhfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
end 
function c21400066.thdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()==2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc1=g:Select(tp,1,1,nil):GetFirst() 
		local tc2=g:Filter(aux.TRUE,tc1):GetFirst()  
		Duel.SendtoHand(tc1,tp,REASON_EFFECT) 
		Duel.SendtoDeck(tc2,nil,2,REASON_EFFECT) 
	end 
end 


