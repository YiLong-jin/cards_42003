--神谕灵断 狐仙霞露零
local m=99982190
local cm=_G["c"..m]
function cm.initial_effect(c)


		c:EnableReviveLimit()  
		aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionCode,99982040),c99982190.FusFilter2,1,true)
	
		--repeat attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1,m)
	e4:SetCondition(c99982190.damcon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	
	--e5
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m+1)
	e5:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.cof5,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cof5,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end)
	e5:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			if e:GetLabel()==0 then return false end
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(cm.tf5,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		end
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,cm.tf5,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		local code=g:GetFirst():GetOriginalCode()
		Duel.Hint(HINT_CARD,1-tp,code)
		local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		Duel.ClearOperationInfo(0)
	end)
	e5:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local te=e:GetLabelObject()
		if te then
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end)
	c:RegisterEffect(e5)
	
end
function c99982190.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToHand() end
	local atk=tc:GetTextAttack()
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	local atk=tc:GetTextAttack()
	if atk<0 then atk=0 end
	if tc and tc:IsRelateToBattle() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end


--e5
function cm.cof5(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x66d) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.tf5(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x366d) and c:CheckActivateEffect(false,true,false)~=nil
end










function cm.FusFilter2(c)
	return c:IsSetCard(0x66d)
end
