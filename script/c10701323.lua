--命运女郎·安妮
function c10701323.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10701323.sprcon)
	e2:SetOperation(c10701323.sprop)
	c:RegisterEffect(e2)  
	--atk,def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c10701323.value)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)  
	--level up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10701323,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(c10701323.lvcon)
	e5:SetOperation(c10701323.lvop)
	c:RegisterEffect(e5)
	--remove,lvup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10701323,1))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,10701323)
	e6:SetTarget(c10701323.rmtg)
	e6:SetOperation(c10701323.rmop)
	c:RegisterEffect(e6)
end
function c10701323.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c10701323.mnfilter(c,g)
	return g:IsExists(c10701323.mnfilter2,1,c,c)
end
function c10701323.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1
end
function c10701323.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c10701323.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c10701323.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10701323.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c10701323.fselect,2,2,tp,c)
end
function c10701323.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c10701323.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c10701323.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c10701323.value(e,c)
	return c:GetLevel()*200
end
function c10701323.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10701323.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701323.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelAbove(12) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10701323.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701323,2)) 
	   and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701323.tgfilter(c,tp)
	return c:IsSetCard(0x31) and c:IsLevelAbove(1) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c10701323.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function c10701323.rmfilter(c)
	return (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c10701323.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10701323.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10701323.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10701323.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
end
function c10701323.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ec=nil
	if tc:IsRelateToEffect(e) then
		ec=tc
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701323.rmfilter),tp,LOCATION_MZONE+LOCATION_HAND,0,1,99,ec,tp)
	if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(10701323,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c10701323.retcon)
		e1:SetOperation(c10701323.retop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		local lv=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if lv>0 and tc:IsRelateToEffect(e) then
			local op=0
			if tc:IsLevelBelow(lv) then op=Duel.SelectOption(tp,aux.Stringid(10701323,3))
			else op=Duel.SelectOption(tp,aux.Stringid(10701323,3),aux.Stringid(10701323,4)) end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			if op==0 then
				e1:SetValue(lv)
			else
				e1:SetValue(-lv)
			end
			tc:RegisterEffect(e1)
		end
	end
end
function c10701323.retfilter(c,fid)
	return c:GetFlagEffectLabel(10701323)==fid
end
function c10701323.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c10701323.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c10701323.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c10701323.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		if tc==e:GetHandler() then
			Duel.ReturnToField(tc)
		else
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
		tc=sg:GetNext()
	end
end