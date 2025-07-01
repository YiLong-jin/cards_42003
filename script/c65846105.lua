--彩虹 彩光
function c65846105.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65846105,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetCountLimit(1,65846105)
	e0:SetCondition(c65846105.spcon)
	e0:SetTarget(c65846105.sptg)
	e0:SetOperation(c65846105.spop)
	c:RegisterEffect(e0)	
	local e3=Effect.CreateEffect(c)
	--e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	--e3:SetCountLimit(1,65846105)
	e3:SetCondition(c65846105.drcon)
	e3:SetTarget(c65846105.drtg)
	e3:SetOperation(c65846105.drop)
	c:RegisterEffect(e3)
end
c65846105.SetCard_ZJ_CH=true
function c65846105.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE) 
end
function c65846105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c65846105.spop(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c65846105.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local lv=0
		if Duel.SelectYesNo(tp,aux.Stringid(65846105,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74644400,2))
			lv=Duel.AnnounceNumber(tp,1,2)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lv)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c65846105.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO) or c:IsRace(RACE_FAIRY)) and c:IsLocation(LOCATION_EXTRA)
end
function c65846105.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and rc:IsRace(RACE_FAIRY)
end
function c65846105.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,65846105)==0 end
	Duel.RegisterFlagEffect(tp,65846105,RESET_PHASE+PHASE_END,0,1)
end
function c65846105.drop(e,tp,eg,ep,ev,re,r,rp)
	--[[local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)]]
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e1:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end