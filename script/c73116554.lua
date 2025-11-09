--”时久色迁 几近日气“
local cm, m, o = GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c, cm.FusFilter3, 2, true)
	c:SetSPSummonOnce(73116554)

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
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,m)
	e8:SetTarget(c73116554.target)
	e8:SetOperation(c73116554.activate)
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
	return  Duel.IsExistingMatchingCard(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,2,nil)
end

function cm.hsptg(e, tp, eg, ep, ev, re, r, rp, chk, c)
	local g=Duel.GetMatchingGroup(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:CancelableSelect(tp,2,g:GetCount(),nil)
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
function c73116554.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetFlagEffect(73116554)==0
end
function c73116554.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73116554.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c73116554.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c73116554.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)

		----------------------------------------------
			--千年一叹
		local e8=Effect.CreateEffect(tc)
		e8:SetType(EFFECT_TYPE_FIELD)
		e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e8:SetCode(73116554)
		e8:SetRange(LOCATION_MZONE)
		e8:SetTargetRange(1,0)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
							e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_DISABLE)
		tc:RegisterEffect(e8)
		---------------------------------------------
		local e5=Effect.CreateEffect(tc)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		e5:SetValue(1)
		tc:RegisterEffect(e5)
-----------------------------------------------------------------------------------------------------------------------
		local e4=Effect.CreateEffect(tc)
		e4:SetDescription(aux.Stringid(73116554,1))
		e4:SetCategory(CATEGORY_SEARCH)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetCountLimit(m+100)
		e4:SetCondition(c73116554.thcon)
		e4:SetTarget(c73116554.thtg)
		e4:SetOperation(c73116554.thop)
		tc:RegisterEffect(e4)
		end
		tc:RegisterFlagEffect(73116554,RESET_EVENT+RESETS_STANDARD+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(73116554,0))
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
-----------------------------------------------------------------------------------------------------------------------
function c73116554.tgfilter(c)
	return (c:IsSetCard(0x7ae) or c:IsSetCard(0x8ae)) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c73116554.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73116554.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c73116554.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73116554,2))
	local g=Duel.SelectMatchingCard(tp,c73116554.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
