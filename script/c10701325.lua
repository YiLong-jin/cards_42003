--红莲魔共鸣者
function c10701325.initial_effect(c)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e1:SetCondition(c10701325.effcon)
	e1:SetOperation(c10701325.effop)
	c:RegisterEffect(e1)   
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701325,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetTarget(c10701325.sctg)
	e3:SetOperation(c10701325.scop)
	c:RegisterEffect(e3)   
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
				if chk==0 then return Duel.GetCustomActivityCount(10701325,tp,ACTIVITY_SPSUMMON)==0 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(function(e,tc) return tc:IsType(TYPE_SYNCHRO) and not (tc:IsRace(RACE_FIEND) or tc:IsRace(RACE_DRAGON)) and tc:IsLocation(LOCATION_EXTRA) end)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end)
	Duel.AddCustomActivityCounter(10701325,ACTIVITY_SPSUMMON,function(tc) return not (tc:IsType(TYPE_SYNCHRO) and not (tc:IsRace(RACE_FIEND) or tc:IsRace(RACE_DRAGON))) or not tc:IsPreviousLocation(LOCATION_EXTRA) end)   
end
function c10701325.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c,g1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701325.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,g1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,g1)
	end
end
function c10701325.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_SYNCHRO)~=0 and e:GetHandler():GetReasonCard():IsSetCard(0x1045)
end
function c10701325.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(10701325,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c10701325.damval)
	rc:RegisterEffect(e1,true)
	local e3=Effect.CreateEffect(rc)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c10701325.damcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	rc:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(rc)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10701325.regcon)
	e4:SetOperation(c10701325.regop)
	rc:RegisterEffect(e4,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c10701325.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,10701325)==0
end
function c10701325.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,10701325)~=0 or bit.band(r,REASON_EFFECT)==0 then return val end
	Duel.RegisterFlagEffect(tp,10701325,RESET_PHASE+PHASE_END,0,1)
	return val*2
end
function c10701325.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:GetFirst():IsType(TYPE_MONSTER)
end
function c10701325.regop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	Duel.RegisterFlagEffect(tp,10701325,RESET_PHASE+PHASE_END,0,1)
end