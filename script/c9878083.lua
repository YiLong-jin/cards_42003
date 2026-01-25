--Standby Ready
local cm,m=GetID()

function cm.initial_effect(c)
	aux.EnableExtraDeckSummonCountLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function cm.tgsfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_TUNER)
end

function cm.tgsfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_TUNER)
end

function cm.tgsfilter3(g,exg)
	return g:FilterCount(Card.IsType,nil,TYPE_TUNER)==1 and exg:IsExists(Card.IsSynchroSummonable,1,nil,nil,g,#g-1,#g-1)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg1=Duel.GetMatchingGroup(cm.tgsfilter1,tp,0x10,0,nil,e,tp)
	local sg2=Duel.GetMatchingGroup(cm.tgsfilter2,tp,0x10,0,nil,e,tp)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp)>1 and #sg1>0 and #sg2>0
		and Group.__add(sg1,sg2):CheckSubGroup(cm.tgsfilter3,2,2,Duel.GetFieldGroup(tp,0x40,0)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0x50)
end

function cm.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp)>1 then
		local sg1=Duel.GetMatchingGroup(cm.tgsfilter1,tp,0x10,0,nil,e,tp)
		local sg2=Duel.GetMatchingGroup(cm.tgsfilter2,tp,0x10,0,nil,e,tp)
		if #sg1>0 and #sg2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Group.__add(sg1,sg2):SelectSubGroup(tp,cm.tgsfilter3,false,2,2,Duel.GetFieldGroup(tp,0x40,0))
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				Duel.AdjustAll()
				if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==2 then
					local syng=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,0x40,0,nil,nil,sg,#sg-1,#sg-1)
					if syng:GetCount()>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local sync=syng:Select(tp,1,1,nil):GetFirst()
						sync:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
						Duel.SynchroSummon(tp,sync,nil,sg,#sg-1,#sg-1)
					end
				end
			end
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.checkop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(92345028)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and aux.ExtraDeckSummonCountLimit[sump]<=0
end

function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetFlagEffect(m)==0
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,tp) then
		aux.ExtraDeckSummonCountLimit[tp]=aux.ExtraDeckSummonCountLimit[tp]-1
	end
	if eg:IsExists(cm.cfilter,1,nil,1-tp) then
		aux.ExtraDeckSummonCountLimit[1-tp]=aux.ExtraDeckSummonCountLimit[1-tp]-1
	end
end