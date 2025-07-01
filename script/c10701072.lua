--炽天武装 雷米尔
function c10701072.initial_effect(c)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701072,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,10701072)
	e4:SetCondition(c10701072.poscon)
	e4:SetTarget(c10701072.postg)
	e4:SetOperation(c10701072.posop)
	c:RegisterEffect(e4)
	--synchro effect
	local e2=aux.GrandsCychroTargetCheckEffect(c)
	e2:SetCountLimit(1,10701072+1)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
				if chk==0 then return Duel.GetCustomActivityCount(10701047,tp,ACTIVITY_SPSUMMON)==0 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(function(e,tc) return not (tc:IsType(TYPE_SYNCHRO) or tc:IsRace(RACE_FAIRY)) and tc:IsLocation(LOCATION_EXTRA) end)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end)
	Duel.AddCustomActivityCounter(10701047,ACTIVITY_SPSUMMON,function(tc) return (tc:IsType(TYPE_SYNCHRO) or tc:IsRace(RACE_FAIRY)) or not tc:IsPreviousLocation(LOCATION_EXTRA) end)
end
function c10701072.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c10701072.posfilter(c)
	return c:IsFaceup() and (c:IsCanTurnSet() or c:IsSSetable()) and not c:IsLocation(LOCATION_PZONE)
end
function c10701072.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c10701072.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701072.posfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10701072.posfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c10701072.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_MONSTER) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		elseif tc:IsType(TYPE_PENDULUM) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		else 
		Duel.ChangePosition(tc,POS_FACEDOWN)
		end
		tc:RegisterFlagEffect(10701072,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10701072,2))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetTarget(c10701072.sumlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10701072.sumlimit(e,c)
	return c:GetFlagEffect(10701072)>0
end