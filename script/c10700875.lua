--灵兽的召还
function c10700875.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10700875+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10700875.target)
	e1:SetOperation(c10700875.activate)
	c:RegisterEffect(e1)  
	--draw
	--local e5=Effect.CreateEffect(c)
	--e5:SetDescription(aux.Stringid(10700875,1))
	--e5:SetCategory(CATEGORY_TODECK)
	--e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e5:SetProperty(EFFECT_FLAG_DELAY)
	--e5:SetCode(EVENT_REMOVE)
   -- e5:SetCondition(c10700875.tdcon)
	--e5:SetTarget(c10700875.tdtg)
	--e5:SetOperation(c10700875.tdop)
	--c:RegisterEffect(e5) 
	--if not c10700875.global_check then
		--c10700875.global_check=true
		--local ge1=Effect.CreateEffect(c)
		--ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		--ge1:SetCondition(c10700875.checkcon)
		--ge1:SetOperation(c10700875.checkop)
		--Duel.RegisterEffect(ge1,0)
	--end 
end
function c10700875.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10700875.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c10700875.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700875.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10700875.filter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c10700875.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		 if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(10700875,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function c10700875.tdcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return (e:GetHandler():IsReason(REASON_COST) or e:GetHandler():IsReason(REASON_EFFECT)) 
		and re:GetHandler():IsSetCard(0xb5) 
end  
function c10700875.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) 
		   and Duel.GetFlagEffect(tp,10700876)<=Duel.GetFlagEffect(tp,10700875) end
	Duel.RegisterFlagEffect(tp,10700876,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c10700875.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
	   local sg=g:RandomSelect(tp,1)
	   Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c10700875.scfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x40b5) and c:IsControler(tp)
end
function c10700875.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10700875.scfilter,1,nil,tp)
end
function c10700875.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),10700875,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end