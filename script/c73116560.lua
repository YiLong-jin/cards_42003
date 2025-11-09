--“伐谋百世 一朝毁之”
local cm, m, o = GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c, cm.FusFilter3, 4, true)
	c:SetSPSummonOnce(73116560)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)


	local e2 = Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.hspcon)
	e2:SetTarget(cm.hsptg)
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)
	
		--Activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,m)
	e8:SetTarget(c73116560.target)
	e8:SetOperation(c73116560.activate)
	c:RegisterEffect(e8)
	
	
end	
	
	
	
	

function cm.FusFilter3(c)	
	return c:IsFusionSetCard(0x7ae) or c:IsFusionSetCard(0x8ae)
end
	

function cm.FusFilter2(c, tp, sc)
	return c:IsFusionSetCard(0x7ae) and Duel.GetLocationCountFromEx(tp, tp, c, sc) > 0
	 and c:IsAbleToRemoveAsCost()
end

function cm.hspcon(e, c)
	if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.IsExistingMatchingCard(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,4,nil)
end

function cm.hsptg(e, tp, eg, ep, ev, re, r, rp, chk, c)
	local g=Duel.GetMatchingGroup(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:CancelableSelect(tp,4,g:GetCount(),nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end

function cm.hspop(e, tp, eg, ep, ev, re, r, rp, c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
----------------------------------------------------------------------------------------------------------
function c73116560.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetFlagEffect(73116560)==0
end
function c73116560.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73116560.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c73116560.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c73116560.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		----------------------------------------------
			--千年一叹
		local e8=Effect.CreateEffect(tc)
		e8:SetType(EFFECT_TYPE_FIELD)
		e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e8:SetCode(73116560)
									e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e8:SetRange(LOCATION_MZONE)
		e8:SetTargetRange(1,0)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e8)
----------------------------------------------------------------------------------------------------------		
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(73116560,1))
		e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2:SetCountLimit(1,73116560+996)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(c73116560.negcon)
		e2:SetTarget(c73116560.negtg)
		e2:SetOperation(c73116560.negop)
		tc:RegisterEffect(e2)
		---------------------------------------------
		local e3=Effect.CreateEffect(tc)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		end
		tc:RegisterFlagEffect(73116560,RESET_EVENT+RESETS_STANDARD+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(73116560,0))
			local c=e:GetHandler()
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e10=Effect.CreateEffect(c)
			e10:SetCode(EFFECT_CHANGE_TYPE)
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e10:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e10:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e10)
end








----------------------------------------------------------------------------------------------------------		






function c73116560.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c73116560.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c73116560.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end