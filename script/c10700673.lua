--孽驱君主 别西卜
function c10700673.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,10700666)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10700673.slcon)
	e1:SetValue(2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2) 
	--destroy and set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10700673.target)
	e3:SetOperation(c10700673.operation)
	c:RegisterEffect(e3)  
	--become material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c10700673.condition2)
	e4:SetOperation(c10700673.operation2)
	--c:RegisterEffect(e4)   
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700673,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,10700673)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c10700673.spcost)
	e5:SetTarget(c10700673.sptg)
	e5:SetOperation(c10700673.spop)
	c:RegisterEffect(e5)  
	--ritual level
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_RITUAL_LEVEL)
	e6:SetValue(c10700673.rlevel)
	c:RegisterEffect(e6) 
end
function c10700673.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:GetOriginalLeftScale()==6
end
function c10700673.slcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700673.scfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c10700673.desfilter(c)
	return c:IsFaceup()
end
function c10700673.filter(c)
	return c:IsSetCard(0x7cb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10700673.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c10700673.desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c10700673.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10700673.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10700673.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10700673.filter,tp,LOCATION_DECK,0,1,1,nil)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and g:GetCount()>0 and Duel.SSet(tp,g:GetFirst())~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10700673.condition2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c10700673.operation2(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(10700673)==0 then
			--remove
			local e1=Effect.CreateEffect(rc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0xfe,0xff)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetTarget(c10700673.rmtg)
			rc:RegisterEffect(e1,true)
			--damage
			local e2=Effect.CreateEffect(rc)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_REMOVE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c10700673.damop)
			rc:RegisterEffect(e2,true)
			rc:RegisterFlagEffect(10700673,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10700673,0))
		end
		rc=eg:GetNext()
	end
end
function c10700673.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c10700673.dafilter1(c,tp)
	return c:GetOwner()==1-tp
end
function c10700673.dafilter2(c,tp)
	return c:GetOwner()==tp
end
function c10700673.damop(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c10700673.dafilter1,nil,tp)*300
	local d2=eg:FilterCount(c10700673.dafilter2,nil,tp)*300
	Duel.Damage(1-tp,d1,REASON_EFFECT,true)
	Duel.Damage(1-tp,d2,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c10700673.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10700673.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10700673.spfilter(c,e,tp,lv)
	local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if c:IsLocation(LOCATION_EXTRA) then res=Duel.GetLocationCountFromEx(tp)>0 end
	return res and c:IsType(TYPE_RITUAL) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c10700673.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c10700673.cfilter,tp,LOCATION_GRAVE,0,nil)
		return c:IsAbleToRemoveAsCost()
			and Duel.IsExistingMatchingCard(c10700673.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,cg:GetCount())
	end
	local cg=Duel.GetMatchingGroup(c10700673.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c10700673.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,cg:GetCount())
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700673,3))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	if lv>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=cg:Select(tp,lv-1,lv-1,c)
		rg1:Merge(rg2)
	end
	rg1:AddCard(c)
	Duel.Remove(rg1,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c10700673.sfilter(c,e,tp,lv)
	return c:IsType(TYPE_RITUAL) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c10700673.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10700673.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
	  Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	  tc:CompleteProcedure()
	end
end
function c10700673.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsRace(RACE_FIEND) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end