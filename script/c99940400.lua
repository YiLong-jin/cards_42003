--我是什么东西？
function c99940400.initial_effect(c)
	--pendulum summon
--	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	aux.EnableDualAttribute(c)
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
--  spirit return
--  aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(0x01)
	c:RegisterEffect(e0)
	local e1=e0:Clone() 
	e1:SetValue(0x02) 
	c:RegisterEffect(e1)
	local e2=e0:Clone() 
	e2:SetValue(0x04) 
	c:RegisterEffect(e2)	
	local e3=e0:Clone() 
	e3:SetValue(0x08) 
	c:RegisterEffect(e3)	
	local e4=e0:Clone() 
	e4:SetValue(0x20) 
	c:RegisterEffect(e4)   
	--spsummon condition
--  local e5=Effect.CreateEffect(c)
--  e5:SetType(EFFECT_TYPE_SINGLE)
--  e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--  e5:SetCode(EFFECT_SPSUMMON_CONDITION)
--  e5:SetValue(aux.ritlimit)
--  c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c99940400.thcon)
	e6:SetTarget(c99940400.thtg)
	e6:SetOperation(c99940400.thop)
	c:RegisterEffect(e6)
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(99940400,0))
	e16:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e16:SetType(EFFECT_TYPE_IGNITION)
	e16:SetRange(LOCATION_PZONE)
	e16:SetCountLimit(1,99940400)
	e16:SetTarget(c99940400.rtg)
	e16:SetOperation(c99940400.rop)
	c:RegisterEffect(e16) 
	--equip
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(99940400,0))
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(aux.IsDualState)
	e7:SetTarget(c99940400.eqtg)
	e7:SetOperation(c99940400.eqop)
	c:RegisterEffect(e7)
	--unequip
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(99940400,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(aux.IsUnionState)
	e8:SetTarget(c99940400.sptg)
	e8:SetOperation(c99940400.spop)
	c:RegisterEffect(e8)

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UNION_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(1)
	c:RegisterEffect(e9)

	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e14:SetCode(EFFECT_DESTROY_REPLACE)
	e14:SetCondition(aux.IsUnionState)
	e14:SetTarget(c99940400.desreptg)
	e14:SetOperation(c99940400.desrepop)
	c:RegisterEffect(e14)

	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c99940400.dacons)
	e10:SetOperation(c99940400.daops)
	c:RegisterEffect(e10)
	--direct attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_DIRECT_ATTACK)
	e11:SetCondition(c99940400.dircon)
	c:RegisterEffect(e11)

	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetOperation(c99940400.retreg)
	c:RegisterEffect(e12)
	local e17=e12:Clone() 
	e17:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e17)

	local e15=Effect.CreateEffect(c)  
	e15:SetDescription(aux.Stringid(99940400,0))
	e15:SetCategory(CATEGORY_DAMAGE)  
	e15:SetType(EFFECT_TYPE_QUICK_O)  
	e15:SetCode(EVENT_CHAINING)  
	e15:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CARD_TARGET)  
	e15:SetRange(LOCATION_MZONE)  
	e15:SetCountLimit(1,99940401)
	e15:SetCondition(c99940400.flipcon)  
	e15:SetCost(c99940400.flipcost)  
	e15:SetTarget(c99940400.datg)  
	e15:SetOperation(c99940400.daop)  
	c:RegisterEffect(e15) 

----------------------------------------------------------------------------------------------------------
end
function c99940400.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)
end
function c99940400.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99940400.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
-----------------------------------------------------------------------------------------------------------
function c99940400.rfilter(c,e,tp,mg,tc)
	if bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or c:IsLocation(LOCATION_PZONE) and c~=tc then return false end
	mg:RemoveCard(c)
	local lv=c:GetOriginalLevel()
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,"Greater")
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function c99940400.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c99940400.rfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp,mg,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function c99940400.rop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99940400.rfilter),tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp,mg,e:GetHandler())
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetOriginalLevel()
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,"Greater")
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
-----------------------------------------------------------------------------------------------------------
function c99940400.filter(c)
	return c:IsFaceup() and c:GetUnionCount()==0
end
function c99940400.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99940400.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(99940400)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
	and Duel.IsExistingTarget(c99940400.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c99940400.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(99940400,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c99940400.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c99940400.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
	--debuff
	tc:SetCardTarget(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabelObject(tc)
	e1:SetValue(c99940400.eqlimit)
	c:RegisterEffect(e1)
end
function c99940400.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c99940400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(99940400)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(99940400,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c99940400.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
end
function c99940400.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return tg and tg:IsReason(REASON_BATTLE+REASON_EFFECT) and not tg:IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c99940400.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT+REASON_REPLACE)
end
-----------------------------------------------------------------------------------------------------------
function c99940400.dacons(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) and (not e:GetHandler():IsDualState())
end
function c99940400.daops(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,99940400)
	e:GetHandler():EnableDualState()
end
--------------------------------------------------------------------------------------------------------------
function c99940400.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c99940400.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c99940400.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c99940400.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c99940400.cfilter2,tp,0,LOCATION_MZONE,1,nil) 
		and aux.IsDualState(e)
end
--------------------------------------------------------------------------------------------------------------
function c99940400.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnConditionForced)
	e1:SetTarget(c99940400.rettg)
	e1:SetOperation(c99940400.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.SpiritReturnConditionOptional)
	c:RegisterEffect(e2)
end
function c99940400.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not e:GetHandler():IsDualState() then return false end
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.IsPlayerCanDraw(1)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99940400.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--------------------------------------------------------------------------------------------------------------
function c99940400.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and e:GetHandler():IsFacedown()
end
function c99940400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c99940400.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c99940400.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--------------------------------------------------------------------------------------------------------------
function c99940400.flipcon(e,tp,eg,ep,ev,re,r,rp)  
	return rc~=e:GetHandler()
end  
function c99940400.flipcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() end  
	local pos=Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)  
	Duel.ChangePosition(c,pos)
end  
function c99940400.dafilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and not c:IsDualState()
end
function c99940400.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99940400.dafilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99940400.dafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c99940400.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c99940400.dafilter(tc) then
		tc:EnableDualState()
	end
end
















