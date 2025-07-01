--驱动女神性能评测
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(this.atktg)
	e1:SetOperation(this.atkop)
	c:RegisterEffect(e1)
end
function this.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x17df)
end
function this.tcf(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function this.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(this.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(this.tcf,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,this.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,this.tcf,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
end
function this.atkop(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and hc:IsFaceup() and hc:IsRelateToEffect(e) then
		if tc:GetAttack()>hc:GetAttack() then 
			Duel.Remove(hc,POS_FACEDOWN,REASON_EFFECT)
		else 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
