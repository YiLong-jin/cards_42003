--暗金教刺青大师索菲亚
function c2222711.initial_effect(c)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetDescription(aux.Stringid(2222711,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,2222711)
	e2:SetCost(c2222711.setcost)
	e2:SetTarget(c2222711.settg)
	e2:SetOperation(c2222711.setop)
	c:RegisterEffect(e2)
end

function c2222711.setfilter(c)
	return c:IsSetCard(0x257) and c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c2222711.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and aux.dncheck(g)
end
function c2222711.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c2222711.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c2222711.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=2 and g:CheckSubGroup(c2222711.fselect,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c2222711.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c2222711.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,c2222711.fselect,false,2,2)
	if sg and #sg==2 then
		if Duel.SSet(tp,sg)==0 then return end
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end