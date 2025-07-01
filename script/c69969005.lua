--ブルーアイズ・カオス・MAX・ドラゴン
local cm,m,ot=GetID()  
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
	e2:SetValue(aux.ChangeBattleDamage(0,HALF_DAMAGE))
	c:RegisterEffect(e2)
	local e13=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969005,0))
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e13:SetCode(EVENT_DAMAGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCondition(cm.alcon)
	e13:SetTarget(cm.altg)
	e13:SetOperation(cm.alop)
	c:RegisterEffect(e13)
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(cm.condition)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Effect 3 
	local e6=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969005,1))
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.tg)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
end
--Effect 1
function cm.alcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and bit.band(r,REASON_BATTLE)~=0
		and Duel.GetAttacker()==c 
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.altg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.alop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	Duel.ChainAttack()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e2)
end
--Effect 2
function cm.condition(e)
	local c=e:GetHandler()
	return c:IsAttackAbove(3000)
end
--Effect 3 
function cm.sfilter(c,e,tp)
   return c:IsCode(69969014) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969005.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,300)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c69969005.sfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	   if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
			   Duel.ShuffleHand(tp)
			   Duel.BreakEffect()
			   Duel.Damage(tp,300,REASON_EFFECT)
   end 
end