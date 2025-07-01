--天界王 志那都-六根清净
function c10701243.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,10701240)
	--code
	aux.EnableChangeCode(c,86327225,LOCATION_HAND+LOCATION_DECK) 
	--decrease tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701243,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1)
	e1:SetCondition(c10701243.ntcon)
	e1:SetTarget(c10701243.nttg)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701243,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCost(c10701243.cost)
	e2:SetTarget(c10701243.postg)
	e2:SetOperation(c10701243.posop)
	c:RegisterEffect(e2) 
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701243,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c10701243.lfcon)
	e3:SetOperation(c10701243.lfop)
	c:RegisterEffect(e3)  
end
function c10701243.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c10701243.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsType(TYPE_DUAL)
end
function c10701243.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10701243.posfilter(c)
	return c:IsFaceup() and (c:IsCanTurnSet() or c:IsSSetable()) and not c:IsLocation(LOCATION_PZONE)
end
function c10701243.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c10701243.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701243.posfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10701243.posfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c10701243.posop(e,tp,eg,ep,ev,re,r,rp)
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
		tc:RegisterFlagEffect(10701243,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10701243,2))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c10701243.sumlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10701243.sumlimit(e,c)
	return c:GetFlagEffect(10701072)>0
end
function c10701243.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a==Duel.GetAttacker() and bit.band(d:GetBattlePosition(),POS_DEFENSE)~=0
end
function c10701243.lfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end