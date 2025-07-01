--破坏・吞噬者・君临　奥杜因 2025/05/31 23:58:10 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(this.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(this.spcon)
	e2:SetTarget(this.sptg)
	e2:SetOperation(this.spop)
	e2:SetLabel(0)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(this.op)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(this.thtg)
	e4:SetOperation(this.thop)
	c:RegisterEffect(e4)
end
function this.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function this.spcfilter(c)
	return c:IsRace(RACE_WYRM) and not c:IsPublic()
end
function this.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(this.spcfilter,tp,LOCATION_HAND,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hg:GetCount()>=1
end
function this.fselect(g,tp)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(this.spcfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	aux.GCheckAdditional=this.fselect
	local sg=g:SelectSubGroup(tp,aux.TRUE,true,1,#g)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function this.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,rg)
	local ct=rg:GetCount()
	e:SetLabel(ct)
	Duel.ShuffleHand(tp)
	rg:DeleteGroup()
end
function this.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(0)
	if c:IsSummonType(SUMMON_VALUE_SELF) then
		if ct>=1 and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
		if ct>=2 then 
			local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false)
			if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end 
		if ct>=3 then
			Duel.BreakEffect()
			local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			Duel.Destroy(dg,REASON_EFFECT)
		end
		if ct>=4 then 
			local ph=Duel.GetCurrentPhase()
			Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+ph,1)
			local rg=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED)
			Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end 
	end 
end
function this.nfilter(c)
	return c:IsSetCard(0x37a3) and c:IsSummonable(true,nil)
end
function this.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function this.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 
		or not c:IsLocation(LOCATION_HAND) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,this.nfilter,tp,LOCATION_HAND,0,0,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.BreakEffect()
		Duel.Summon(tp,tc,true,nil)
	end
end