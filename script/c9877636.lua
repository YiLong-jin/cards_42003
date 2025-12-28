--旋战鱼武装mk2-梅莉
function c9877636.initial_effect(c)
	c:SetSPSummonOnce(9877636)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9877636.matfilter,2,2)

	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c9877636.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)


	local e11=Effect.CreateEffect(c)  
	e11:SetDescription(aux.Stringid(9877636,1)) 
	e11:SetCategory(CATEGORY_TOGRAVE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_PAY_LPCOST)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCountLimit(1) 
	e11:SetTarget(c9877636.settg)  
	e11:SetOperation(c9877636.setop)  
	c:RegisterEffect(e11)  
	
end
c9877636.SetCard_AY_ML=true
function c9877636.matfilter(c)
	return c:IsLinkSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end
function c9877636.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_TRAP)*-100
end

function c9877636.tgfilter(c)
	return c:IsSetCard(0x17ec) and c:IsAbleToGrave()
end
function c9877636.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c9877636.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end  
function c9877636.setop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9877636.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877636,0)) then
		Duel.BreakEffect()
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_SZONE,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end  