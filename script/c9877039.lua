--对策委员会之记忆-野乃美
local cm,m=GetID()
cm.Benqi_duice=true
function c9877039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c9877039.target)
	e1:SetOperation(c9877039.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(function(e,c)
	return c:IsCode(9877034) end)
	c:RegisterEffect(e2) 
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2) 
	--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c9877039.atkcon)
	e3:SetCost(c9877039.atkcost)
	e3:SetOperation(c9877039.atkop)
	c:RegisterEffect(e3)
	--pos 
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCountLimit(1,9877039) 
	e4:SetCondition(function(e) 
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) end) 
	e4:SetTarget(c9877039.postg) 
	e4:SetOperation(c9877039.posop) 
	c:RegisterEffect(e4) 
end
function c9877039.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsCode(9877034) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsCode(9877034) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9877039.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9877039.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()  
	local bc=ec:GetBattleTarget()
	return bc and bc:GetLevel()>ec:GetLevel() and bc:IsFaceup()
end
function c9877039.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return ec:GetFlagEffect(9877039+1)==0 end
	ec:RegisterFlagEffect(9877039+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c9877039.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget() 
	local bc=ec:GetBattleTarget()
	if ec:IsRelateToBattle() and ec:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(1000)
		ec:RegisterEffect(e1)
	end
end
function c9877039.postg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget() 
	if chk==0 then return ec and not ec:IsLevel(1) end 
	Duel.SetTargetCard(ec) 
end 
function c9877039.posop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget()  
	if ec:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)
		Duel.BreakEffect() 
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ATTACK_ALL)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e4)
	end 
end 




