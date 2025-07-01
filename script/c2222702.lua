--奥秘·爆炸符文
function c2222702.initial_effect(c)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(2222702,1))

	e8:SetType(EFFECT_TYPE_ACTIVATE)
	
	e8:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	--e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	--e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCountLimit(1,2222702)
	e8:SetCondition(c2222702.atkcon)
	e8:SetTarget(c2222702.atktg)
	e8:SetOperation(c2222702.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	local e10=e8:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e10)
end
function c2222702.atkfilter(c,p)
	return c:IsControler(p) and c:IsDefenseAbove(1)
end
function c2222702.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c2222702.atkfilter,1,nil,1-tp)
end
function c2222702.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c2222702.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,2222708,0,0,99)
	local g=eg:Filter(c2222702.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local d=0
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetDefense()
		if preatk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if tc:IsDefense(0) then 
				if d<(2000-preatk) then d=2000-preatk end
				dg:AddCard(tc) 
				local c=e:GetHandler()
				local tcc=tc
				if tcc:IsRelateToEffect(e) and tcc:IsFaceup() then
					Duel.NegateRelatedChain(tcc,RESET_TURN_SET)
		
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tcc:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_EFFECT)
					e3:SetValue(RESET_TURN_SET)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tcc:RegisterEffect(e3)
				end
			end
		end
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,d,REASON_EFFECT)
	Duel.Destroy(dg,REASON_EFFECT)
end












