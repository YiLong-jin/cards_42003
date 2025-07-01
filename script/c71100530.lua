--次元世界@游希叶界
local this,id,ofs=GetID()
function this.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(this.atkval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(this.spcon)
	e3:SetTarget(this.sptg)
	e3:SetOperation(this.spop)
	c:RegisterEffect(e3)
end
function this.atkfilter(c)
	return c:IsFaceup() and c:GetAttribute()~=0
end
function this.atkval(e,c)
	local g=Duel.GetMatchingGroup(this.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return aux.GetAttributeCount(g)*300
end
function this.cfilter(c)
	return c:IsSetCard(0x17df) and c:IsSummonLocation(LOCATION_EXTRA) 
end
function this.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(this.cfilter,nil)==1 
end
function this.tgfilter(c,e,tp,eg)
	local sc=eg:Filter(this.cfilter,nil):GetFirst()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17df) and Duel.GetMZoneCount(tp)>0 and not c:IsAttribute(sc:GetAttribute())
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.tgfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,eg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(this.tgfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,eg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
