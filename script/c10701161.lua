--炼金兽・铜之鳞蟒
function c10701161.initial_effect(c)
	aux.AddCodeList(c,10701151)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10701161.splimit)
	c:RegisterEffect(e1) 
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)  
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701161,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCountLimit(1,10701161)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c10701161.stcon)
	e3:SetTarget(c10701161.sttg)
	e3:SetOperation(c10701161.stop)
	c:RegisterEffect(e3) 
end
function c10701161.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c10701161.stcon(e,tp,eg,ep,ev,re,r,rp)
	return not (e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) and e:GetHandler():IsSummonLocation(LOCATION_DECK))
end
function c10701161.stfilter1(c)
	return c:IsCode(10701151) and c:IsSSetable()
end
function c10701161.stfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,10701151) and c:IsSSetable()
end
function c10701161.filter(c)
	return c:IsCode(10701151) and c:IsFaceup()
end
function c10701161.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local b1=Duel.IsExistingMatchingCard(c10701161.stfilter1,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c10701161.stfilter2,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c10701161.filter,tp,LOCATION_SZONE,0,1,nil)
		return b1 or b2
	end
end
function c10701161.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701161.stfilter1,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil)
	if Duel.IsExistingMatchingCard(c10701161.filter,tp,LOCATION_SZONE,0,1,nil) then
		local eg=Duel.GetMatchingGroup(c10701161.stfilter2,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SSet(tp,tg)
	end
end