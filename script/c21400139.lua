--巴托尼亚-农民长弓团
function c21400139.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400139+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21400139.hspcon)
	c:RegisterEffect(e1)   
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)   
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,21400140) 
	e2:SetCondition(c21400139.descon)
	e2:SetTarget(c21400139.destg) 
	e2:SetOperation(c21400139.desop) 
	c:RegisterEffect(e2) 
end
function c21400139.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5211) and c:IsLevelAbove(5) 
end
function c21400139.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c21400139.hfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c21400139.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS) and e:GetHandler():IsType(TYPE_TRAP)  
end 
function c21400139.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) end 
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) 
	g:AddCard(e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c21400139.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local dg=Group.CreateGroup() 
	if tc:IsRelateToEffect(e) then dg:AddCard(tc) end  
	if c:IsRelateToEffect(e) then dg:AddCard(c) end 
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 




