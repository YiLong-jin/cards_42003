--芳香大法师-欧白芷
function c16759968.initial_effect(c)
	  --Special Summon from a hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16759968,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16759968)
	e1:SetCondition(c16759968.spcon)
	e1:SetTarget(c16759968.sptg)
	e1:SetOperation(c16759968.spop)
	c:RegisterEffect(e1)


--lv change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16759968,0))
	e4:SetCategory(CATEGORY_LVCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c16759968.tg)
	e4:SetOperation(c16759968.op)
	c:RegisterEffect(e4)


   --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16759968,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16759968)
	e2:SetCondition(c16759968.sgcon)
	e2:SetTarget(c16759968.sgtg)
	e2:SetOperation(c16759968.sgop)
	c:RegisterEffect(e2)
end
function c16759968.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc9)
end
function c16759968.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16759968.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16759968.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16759968.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end




function c16759968.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsLevelAbove(1) and c:IsFaceup() end
	local lv=c:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	e:SetLabel(Duel.AnnounceLevel(tp,1,4,lv))
end
function c16759968.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end




function c16759968.ffilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc9) and (c:IsType(TYPE_LINK) or c:IsType(TYPE_SYNCHRO))
end
function c16759968.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>Duel.GetLP(1-tp) and Duel.IsExistingMatchingCard(c16759968.ffilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16759968.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16759968.sgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end