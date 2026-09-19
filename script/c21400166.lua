--巴托尼亚-济世圣杯骑士
function c21400166.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,function(c) return c:IsFusionSetCard(0x5211) and c:IsLevelAbove(5) and c:GetOriginalType()&TYPE_MONSTER~=0 end,function(c) return c:IsFusionSetCard(0x5211) and c:GetOriginalType()&TYPE_MONSTER~=0 end,2,2,true) 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21400166.ContactFusionCondition(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetTarget(c21400166.ContactFusionTarget(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetOperation(c21400166.ContactFusionOperation(Duel.SendtoGrave,REASON_SPSUMMON+REASON_MATERIAL))
	c:RegisterEffect(e0)  
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,21400166) 
	e2:SetCondition(c21400166.plcon)
	e2:SetTarget(c21400166.pltg)
	e2:SetOperation(c21400166.plop)
	c:RegisterEffect(e2)
	--sp 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,21400167) 
	e3:SetCondition(c21400166.spcon)
	e3:SetTarget(c21400166.sptg)
	e3:SetOperation(c21400166.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21400166,ACTIVITY_CHAIN,c21400166.chainfilter)
end
function c21400166.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(21400172) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c21400166.crmfil(c) 
	return c:IsAbleToRemove() and c:IsCode(21400172) 
end 
function c21400166.ContactFusionCondition(filter,self_location,opponent_location)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200) and Duel.GetCustomActivityCount(21400166,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(21400166,1-tp,ACTIVITY_CHAIN)>0 and Duel.IsExistingMatchingCard(c21400166.crmfil,tp,LOCATION_GRAVE,0,1,nil)
			end
end
function c21400166.ContactFusionTarget(filter,self_location,opponent_location)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				if #g>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					local tc=Duel.SelectMatchingCard(tp,c21400166.crmfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
					Duel.Remove(tc,POS_FACEUP,REASON_SPSUMMON)
					return true
				else return false end
			end
end
function c21400166.ContactFusionOperation(mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_MATERIAL+REASON_FUSION)
				g:DeleteGroup()
			end
end
function c21400166.plcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(21400172) end,tp,LOCATION_REMOVED,0,3,nil)
end 
function c21400166.plfilter(c)
	return c:IsSetCard(0x5211) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c21400166.pltg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400166.plfilter,tp,LOCATION_GRAVE,0,1,nil) and ft>0 end
end
function c21400166.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>2 then ft=2 end 
	if Duel.IsExistingMatchingCard(c21400166.plfilter,tp,LOCATION_GRAVE,0,1,nil) and ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c21400166.plfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
		local tc=g:GetFirst()
		while tc do 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e2) 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(function(e,c)
			return c:IsCode(e:GetLabel()) end)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		tc=g:GetNext() 
		end
	end
end
function c21400166.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp  
end 
function c21400166.sfilter(c,e,tp)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:GetType()&TYPE_CONTINUOUS+TYPE_TRAP==TYPE_CONTINUOUS+TYPE_TRAP and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400166.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c21400166.sfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21400166.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21400166.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21400166.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end
end



