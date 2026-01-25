--想起「乐园的引力」 2026/01/07 01:01:16 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	c:EnableCounterPermit(0x17d7)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(this.condition)
	e1:SetTarget(this.target)
	e1:SetOperation(this.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--counter set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(this.stcon)
	e3:SetOperation(this.stop)
	c:RegisterEffect(e3)
end
function this.cfilter(c,tp)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)*400
	return c:IsSummonPlayer(1-tp) and c:IsFaceup() and c:GetDefense()<ct
end
function this.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(this.cfilter,1,nil,tp)
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(this.cfilter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function this.filter(c,e)
	return c:IsRelateToEffect(e)
end
function this.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local g=eg:Filter(this.filter,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function this.stcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function this.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function this.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCanAddCounter(0x17d7,1) then
		c:AddCounter(0x17d7,1)
	end
	if c:GetCounter(0x17d7)>=2 then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if c:IsLocation(LOCATION_DECK) then
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(this.spfilter),tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
			if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
		end
	end
end
