--北方的暴君 魔王·罗莎莉亚
local m=99951020
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcCodeFun(c,9990740,cm.ffilter,3,true,true)

	--[[indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
 	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	 e1:SetRange(LOCATION_MZONE)
	 e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
 	e1:SetValue(1)
 	 c:RegisterEffect(e1)
 	 local e2=e1:Clone()
	  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  	c:RegisterEffect(e2)
	--cannot be target
--- local e3=Effect.CreateEffect(c)
--  e3:SetType(EFFECT_TYPE_SINGLE)
 --   e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
 --   e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
 --   e3:SetRange(LOCATION_MZONE)
 --   e3:SetValue(cm.efilter)
  --  c:RegisterEffect(e3)]]




	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(3,m+1)
	e4:SetCondition(cm.discon)
	e4:SetCost(cm.discost)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)





	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,2))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCondition(cm.pencon)
	e8:SetCost(cm.pencost)
	e8:SetTarget(cm.pentg)
	e8:SetOperation(cm.penop)
	c:RegisterEffect(e8)
	--Effect 2
	local e32=Effect.CreateEffect(c)
	e32:SetDescription(aux.Stringid(m,4))
	e32:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e32:SetType(EFFECT_TYPE_IGNITION)
	e32:SetRange(LOCATION_PZONE)
	e32:SetCountLimit(1)
	e32:SetTarget(cm.rettg)
	e32:SetOperation(cm.retop)
	c:RegisterEffect(e32) 
end
function cm.cfilter1(c)
	return c:IsSetCard(0x671) and c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.efilter11)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
			local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,c)
			if #g>0 then Duel.BreakEffect() end
			for tc in aux.Next(g) do
			local atk2=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(math.ceil(atk2/2))
			tc:RegisterEffect(e1)
		end
	end
end
function cm.efilter11(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end













function cm.cfilter(c)
	return c:IsSetCard(0x671) and c:IsAbleToRemoveAsCost()
end
function cm.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end











function cm.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end





--Effect 2
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)  then return end
	if  Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_EXTRA) then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
		local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) 
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			local tc=c
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end
function cm.filter1(c,e)
	return  not c:IsImmuneToEffect(e) and c:IsAbleToRemove()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c==e:GetHandler() and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end




function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x673)
end