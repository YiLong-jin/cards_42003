--思念体★死亡主宰·觉醒
function c69969023.initial_effect(c)
aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c69969023.hspcon)
	e2:SetTarget(c69969023.hsptg)
	e2:SetOperation(c69969023.hspop)
	c:RegisterEffect(e2)
 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969023,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c69969023.sptg)
	e3:SetOperation(c69969023.spop)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c69969023.tgcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(69969023,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c69969023.spxtg)
	e6:SetOperation(c69969023.spxop)
	c:RegisterEffect(e6)
end
function c69969023.hspfilter(c,tp,sc)
	return c:IsCode(69969008) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:GetCounter(0x698)>=8
end
function c69969023.hspcon(e,c)
if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c69969023.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
	end
function c69969023.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c69969023.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c69969023.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end
--1
function c69969023.chainlm(e,ep,tp)
	return tp==ep
end
function c69969023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969021,0,TYPES_TOKEN_MONSTER,2500,2500,8,RACE_ZOMBIE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetChainLimit(c69969023.chainlm)
end
function c69969023.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,69969021,0,TYPES_TOKEN_MONSTER,2500,2500,8,RACE_ZOMBIE,ATTRIBUTE_EARTH) then
		local token1=Duel.CreateToken(tp,69969021)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local token2=Duel.CreateToken(tp,69969021)
		if Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)==0 then return end 
		Duel.SpecialSummonComplete()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1) then return end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,69969024,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_ZOMBIE,ATTRIBUTE_EARTH)
			and Duel.SelectYesNo(tp,aux.Stringid(69969023,0)) then
			Duel.BreakEffect()
			local c=e:GetHandler()
			for i=1,ft do
				local token=Duel.CreateToken(tp,69969023+i)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
end
		Duel.SpecialSummonComplete()
	end
end
end
--2
function c69969023.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c69969023.tgcon(e)
	return Duel.IsExistingMatchingCard(c69969023.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
--3
function c69969023.relfilter(c)
	return c:IsFaceup() and c:IsReleasableByEffect() and c:IsType(TYPE_TOKEN)
end
function c69969023.adfilter(c,f)
	return math.max(f(c),0)
end
function c69969023.costfilter(c)
	return c:IsFaceup() and c:IsReleasableByEffect() and c:IsType(TYPE_TOKEN)
end
function c69969023.spxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c69969023.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 and Duel.GetMZoneCount(tp,g)>0 and Duel.GetMZoneCount(tp,g,tp)>0
		and Duel.IsPlayerCanRelease(tp)
		and Duel.IsPlayerCanSpecialSummonCount(tp,1)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969019,0,TYPES_TOKEN_MONSTER,g:GetSum(c69969023.adfilter,Card.GetTextAttack),g:GetSum(c69969023.adfilter,Card.GetTextDefense),11,RACE_ZOMBIE,ATTRIBUTE_EARTH,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetChainLimit(c69969023.chainlm)
end
function c69969023.spxop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c69969023.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local c=e:GetHandler()
			if og:GetCount()==0 then return end
			local atk=og:GetSum(c69969023.adfilter,Card.GetTextAttack)
			local def=og:GetSum(c69969023.adfilter,Card.GetTextDefense)
			if Duel.GetLocationCount(tp,LOCATION_MZONE,tp)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,69969019,0,TYPES_TOKEN_MONSTER,atk,def,11,RACE_ZOMBIE,ATTRIBUTE_EARTH,POS_FACEUP,tp) then
				local token=Duel.CreateToken(tp,69969019)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE)
				e2:SetValue(def)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end