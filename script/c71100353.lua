--V城默示录 真心为你
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Destroy and Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(276357,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--change pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2521011,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(cm.set_checkop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.act_checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.set_checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local cg=eg:Filter(Card.IsCode,nil,m)
	local tc=cg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,re:GetHandler():GetCode())
		tc=cg:GetNext()
	end
end
function cm.act_checkop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return end
	Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_BATTLE,0,1)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp~=tp and rc:IsDestructable() and rc:IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL)
end
function cm.actf(c,ec)
	return c:IsCode(ec:GetFlagEffectLabel(m)) and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.actf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end 
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then 
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetFlagEffect(1-tp,m)>0
		and Duel.IsExistingMatchingCard(cm.pos,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.pos(c)
	return c:IsCanTurnSet() and not c:IsLocation(LOCATION_PZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetFlagEffect(1-tp,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.pos,tp,0,LOCATION_ONFIELD,1,ft,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local xg=Group.CreateGroup()
		while tc do   
			if tc:GetOriginalType()&TYPE_MONSTER==0 and Duel.ChangePosition(tc,POS_FACEDOWN)>0 then
				xg:AddCard(tc)
			elseif tc:GetOriginalType()&TYPE_MONSTER>0  then
				Duel.ChangePosition(tc,POS_FACEDOWN)
			end 
			tc=g:GetNext()
		end
		if #xg>0 then
			Duel.RaiseEvent(xg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end 
	end
end
