--对策委员会之记忆-星野
local cm,m=GetID()
cm.Benqi_duice=true
function c9877037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c9877037.target)
	e1:SetOperation(c9877037.operation)
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
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2) 
	--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
	--pos 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetRange(LOCATION_SZONE)   
	e4:SetCountLimit(1,9877037)
	e4:SetCondition(function(e) 
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) end) 
	e4:SetTarget(c9877037.postg) 
	e4:SetOperation(c9877037.posop) 
	c:RegisterEffect(e4) 
end
function c9877037.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsCode(9877034) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsCode(9877034) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9877037.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9877037.postg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget() 
	if chk==0 then return ec and ec:IsCanChangePosition() and not ec:IsPosition(POS_FACEUP_DEFENSE) end 
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,ec,1,0,0) 
end 
function c9877037.posop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget()  
	if ec:IsRelateToEffect(e) and Duel.ChangePosition(ec,POS_FACEUP_DEFENSE)~=0 then 
		Duel.BreakEffect() 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(2000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1) 
	end 
end 



