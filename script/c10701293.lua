--极星兽 阿尔斯维
function c10701293.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(c10701293.tnval)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701293,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,10701293)
	e2:SetTarget(c10701293.sptg)
	e2:SetOperation(c10701293.spop)
	c:RegisterEffect(e2) 
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701293,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1,10701294)
	e3:SetTarget(c10701293.sctg)
	e3:SetOperation(c10701293.scop)
	c:RegisterEffect(e3)   
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
				if chk==0 then return Duel.GetCustomActivityCount(10701293,tp,ACTIVITY_SPSUMMON)==0 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(function(e,tc) return tc:IsType(TYPE_SYNCHRO) and not tc:IsSetCard(0x4b) and tc:IsLocation(LOCATION_EXTRA) end)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end)
	Duel.AddCustomActivityCounter(10701293,ACTIVITY_SPSUMMON,function(tc) return not (tc:IsType(TYPE_SYNCHRO) and not c:IsSetCard(0x4b)) or not tc:IsPreviousLocation(LOCATION_EXTRA) end)
end
function c10701293.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsSetCard(0x4b)
end
function c10701293.synfilter(c,g)
	return c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c10701293.cfilter(c,e)
	return c==e:GetHandler()
end
function c10701293.fselect(g,e,tp)
	return g:IsExists(c10701293.cfilter,1,nil,e) and Duel.IsExistingMatchingCard(c10701293.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c10701293.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if chk==0 then return c:GetFlagEffect(10701293)==0 and g:CheckSubGroup(c10701293.fselect,2,#g,e,tp) end
	c:RegisterFlagEffect(10701293,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701293.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectSubGroup(tp,c10701293.fselect,false,2,#g,e,tp)
	local scg=Duel.GetMatchingGroup(c10701293.synfilter,tp,LOCATION_EXTRA,0,nil,sg)
	if scg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=scg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,rg:GetFirst(),nil,sg)
	end
end
function c10701293.spfilter(c,e,tp)
	return c:IsSetCard(0x42,0x4b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701293.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701293.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10701293.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701293.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end