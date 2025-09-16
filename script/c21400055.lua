--奸奇粉色惧妖
function c21400055.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400055,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400055)
	--e1:SetCost(c21400055.setcost)
	e1:SetTarget(c21400055.settg)
	e1:SetOperation(c21400055.setop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400055,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,11400055)
	e2:SetCondition(c21400055.spcon)
	e2:SetTarget(c21400055.sptg)
	e2:SetOperation(c21400055.spop)
	c:RegisterEffect(e2)
	if not c21400055.global_check then
		c21400055.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c21400055.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c21400055.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsSetCard(0x3210) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		Duel.RegisterFlagEffect(rp,21400055,RESET_PHASE+PHASE_END,0,1) 
	end
end
function c21400055.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c21400055.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c21400055.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c21400055.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c21400055.setfilter(c)
	return c:IsSetCard(0x3210) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21400055.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400055.setfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToGrave() and Duel.IsExistingMatchingCard(c21400055.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end   
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND)
end
function c21400055.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		local sg=Duel.SelectMatchingCard(tp,c21400055.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		sg:AddCard(c) 
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c21400055.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end 
	end 
end
function c21400055.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,21400055)+Duel.GetFlagEffect(1-tp,21400055)~=0 
end
function c21400055.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400055.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end





