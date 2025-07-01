--暗面魔法少女 八云御魂
function c99900620.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99900620)
	e1:SetCondition(c99900620.con)
	e1:SetOperation(c99900620.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(99900620,ACTIVITY_CHAIN,aux.FALSE)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99900630,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c99900620.indcon)
	e4:SetOperation(c99900620.indop)
	c:RegisterEffect(e4)
------------------------------------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900620.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(99900620,1-tp,ACTIVITY_CHAIN)~=0 
end
function c99900620.activate(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("你TM发效果啊你倒是发效果啊我要卡组选素材啊！！！！！！！！！！！")
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(99900620,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c99900620.chain_target)
	e1:SetOperation(c99900620.chain_operation)
	e1:SetValue(c99900620.filter1)
	Duel.RegisterEffect(e1,tp)
end
function c99900620.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:IsLevelBelow(7)
end
function c99900620.filter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c99900620.chain_target(e,te,tp)
	return Duel.GetMatchingGroup(c99900620.filter,tp,LOCATION_DECK,0,nil,te)
end
function c99900620.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
	e:Reset()
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900620.indcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0 
		and e:GetHandler():GetReasonCard():IsSetCard(0x676)
end
function c99900620.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99900620,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c99900620.atkcon)
	e1:SetCost(c99900620.atkcost)
	e1:SetOperation(c99900620.atkop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99900630,2))
	Duel.Readjust()
end
function c99900620.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c99900620.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(99900620)==0 end
	c:RegisterFlagEffect(99900620,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c99900620.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=c:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_DISABLE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------