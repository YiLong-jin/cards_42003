--司宙救世 2025/11/02 00:51:07 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	aux.AddCodeList(c,71000202)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.rtcon)
	e1:SetTarget(this.rttg)
	e1:SetOperation(this.rtop)
	c:RegisterEffect(e1)
	--atk up and effect lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+ofs)
	e2:SetCondition(this.atkcon)
	e2:SetOperation(this.atkop)
	c:RegisterEffect(e2)
end
function this.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsCode(71000202) and c:IsFaceup() end,tp,LOCATION_MZONE,0,1,nil)
end
function this.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0):Filter(Card.IsCanBeEffectTarget,nil,e)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(Card.IsCanBeEffectTarget,nil,e)
	g1:RemoveCard(c)
	local ct1=#g1
	local ct2=#g2
	if chk==0 then return ct1>0 and ct2>0 end
	local num=math.min(ct1,ct2)
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg1=g1:Select(tp,1,num,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg2=g2:Select(tp,#sg1,#sg1,nil)
	sg:Merge(sg1)
	sg:Merge(sg2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function this.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function this.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(function(c) return c:IsCode(71000202) and c:IsFaceup() end,tp,LOCATION_MZONE,0,1,nil)
end
function this.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local atk=g:GetSum(Card.GetAttack)
	local tg=Duel.GetMatchingGroup(function(c) return c:IsCode(71000202) and c:IsFaceup() end,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(tg) do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e2,tp)
end
