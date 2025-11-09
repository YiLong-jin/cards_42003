--”其数为九 角似赤铜“
local cm, m, o = GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c, cm.FusFilter3, 1, true)
	c:SetSPSummonOnce(73116552)

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
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetTarget(c73116552.target)
	e8:SetOperation(c73116552.activate)
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
	return  Duel.IsExistingMatchingCard(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end

function cm.hsptg(e, tp, eg, ep, ev, re, r, rp, chk, c)
	local g=Duel.GetMatchingGroup(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:CancelableSelect(tp,1,g:GetCount(),nil)
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
function c73116552.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetFlagEffect(73116552)==0
end
function c73116552.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_FIELD,e:GetHandler(),1,0,0)
end
function c73116552.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e10=Effect.CreateEffect(c)
	e10:SetCode(EFFECT_CHANGE_TYPE)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e10:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e10)

	if Duel.IsExistingMatchingCard(c73116552.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(73116552,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c73116552.filter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
-----------------------------------------------------------------------------------------------------------------------
				--千年一叹
			local e8=Effect.CreateEffect(tc)
			e8:SetType(EFFECT_TYPE_FIELD)
			e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e8:SetCode(73116552)
			e8:SetRange(LOCATION_MZONE)
					e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e8:SetTargetRange(1,0)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e8)
-----------------------------------------------------------------------------------------------------------------------
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(900)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
-----------------------------------------------------------------------------------------------------------------------
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_EQUIP)
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			e3:SetValue(900)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
				--fusion
			local e4=Effect.CreateEffect(tc)
			e4:SetDescription(aux.Stringid(m,1))
			e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER+TIMING_SSET,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER+TIMING_SSET)
			e4:SetRange(LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetCountLimit(1,m+1)
			e4:SetTarget(cm.futg)
			e4:SetOperation(cm.fuop)
			tc:RegisterEffect(e4)
			
			tc:RegisterFlagEffect(73116552,RESET_EVENT+RESETS_STANDARD+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(73116552,0))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------
function cm.filter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function cm.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToRemove()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return cm.spfilter(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.spfilter(c)
	return c:IsSetCard(0x8ae) and c:IsType(TYPE_FUSION)
end
function cm.futg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.fuop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end






