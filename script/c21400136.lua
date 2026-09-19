--巴托尼亚-农民步兵团
function c21400136.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400136+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21400136.hspcon)
	c:RegisterEffect(e1)   
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,21400137) 
	e2:SetCondition(c21400136.descon)
	e2:SetTarget(c21400136.destg) 
	e2:SetOperation(c21400136.desop) 
	c:RegisterEffect(e2) 
end
function c21400136.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5211) and c:IsLevelAbove(5) 
end
function c21400136.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c21400136.hfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c21400136.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS) and e:GetHandler():IsType(TYPE_TRAP)  
end 
function c21400136.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end 
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler()) 
	g:AddCard(e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c21400136.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local dg=Group.CreateGroup() 
	if tc:IsRelateToEffect(e) then dg:AddCard(tc) end  
	if c:IsRelateToEffect(e) then dg:AddCard(c) end 
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 



