--巴托尼亚-真正的活圣人
function c21400169.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,function(c) return c:IsFusionSetCard(0x5211) and c:IsLevelAbove(5) and c:GetOriginalType()&TYPE_MONSTER~=0 end,1,127,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21400169.ContactFusionCondition(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetTarget(c21400169.ContactFusionTarget(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetOperation(c21400169.ContactFusionOperation(Duel.SendtoGrave,REASON_SPSUMMON+REASON_MATERIAL))
	c:RegisterEffect(e0) 
	--set
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,21400169)
	e1:SetCost(c21400169.setcost)
	e1:SetTarget(c21400169.settg)
	e1:SetOperation(c21400169.setop)
	c:RegisterEffect(e1)
	--indes 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x5211) and c:IsLevelBelow(4) end) 
	e2:SetValue(1)  
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x5211) and c:IsLevelBelow(4) end) 
	e2:SetValue(aux.indoval)  
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(21400169,ACTIVITY_CHAIN,c21400169.chainfilter)
end
function c21400169.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(21400172) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c21400169.crmfil(c) 
	return c:IsAbleToRemove() and c:IsCode(21400172) 
end 
function c21400169.ContactFusionCondition(filter,self_location,opponent_location)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200) and Duel.GetCustomActivityCount(21400169,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(21400169,1-tp,ACTIVITY_CHAIN)>0 and Duel.IsExistingMatchingCard(c21400169.crmfil,tp,LOCATION_GRAVE,0,1,nil)
			end
end
function c21400169.ContactFusionTarget(filter,self_location,opponent_location)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				if #g>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					local tc=Duel.SelectMatchingCard(tp,c21400169.crmfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
					Duel.Remove(tc,POS_FACEUP,REASON_SPSUMMON)
					return true
				else return false end
			end
end
function c21400169.ContactFusionOperation(mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_MATERIAL+REASON_FUSION)
				g:DeleteGroup()
			end
end
function c21400169.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c21400169.setfilter(c)
	return c:IsSetCard(0x5211) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c21400169.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400169.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21400169.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c21400169.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(21400169,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(21400169,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end




