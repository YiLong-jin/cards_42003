--纳垢瘟疫食人魔
function c21400102.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsFusionSetCard(0x9210) end,2,true)
	--destroy
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,21400102)
	e1:SetTarget(c21400102.destg)
	e1:SetOperation(c21400102.desop)
	c:RegisterEffect(e1)
	--chain atk 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,11400102)
	e2:SetCondition(c21400102.chacon) 
	e2:SetCost(c21400102.chacost)
	e2:SetTarget(c21400102.chatg)
	e2:SetOperation(c21400102.chaop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c21400102.distg)
	c:RegisterEffect(e3)
end
function c21400102.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetCounter(0x1077)>0 end
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:GetCounter(0x1077)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,function(c) return c:GetCounter(0x1077)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21400102.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) and tc:GetBaseAttack()>0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(tc:GetBaseAttack()) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c21400102.chacon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end 
function c21400102.ctfil(c) 
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x9210) and c:IsFaceup()  
end 
function c21400102.chacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400102.ctfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end  
	local sg=Duel.SelectMatchingCard(tp,c21400102.ctfil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()) 
	Duel.SendtoGrave(sg,REASON_COST)
end
function c21400102.chatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsChainAttackable() end 
end
function c21400102.chaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end 
function c21400102.distg(e,c)
	return c==e:GetHandler():GetBattleTarget() and c:GetCounter(0x1077)>0 
end

