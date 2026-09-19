--巴托尼亚-归乡骑士
function c21400154.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsFusionSetCard(0x5211) and c:GetOriginalType()&TYPE_MONSTER~=0 end,2,true) 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21400154.ContactFusionCondition(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetTarget(c21400154.ContactFusionTarget(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetOperation(c21400154.ContactFusionOperation(Duel.SendtoGrave,REASON_SPSUMMON+REASON_MATERIAL+REASON_FUSION))
	c:RegisterEffect(e0)
	--place
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,21400154)
	e1:SetTarget(c21400154.pltg)
	e1:SetOperation(c21400154.plop)
	c:RegisterEffect(e1)
	--fusme 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21400155)
	e2:SetCondition(c21400154.fumcon)
	e2:SetTarget(c21400154.fumtg)
	e2:SetOperation(c21400154.fumop)
	c:RegisterEffect(e2)
	--ctre
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,21400156) 
	e3:SetCondition(c21400154.ctrecon)
	e3:SetTarget(c21400154.ctretg)
	e3:SetOperation(c21400154.ctreop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21400154,ACTIVITY_CHAIN,c21400154.chainfilter)
end
function c21400154.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(21400172) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c21400154.crmfil(c) 
	return c:IsAbleToRemove() and c:IsCode(21400172) 
end 
function c21400154.ContactFusionCondition(filter,self_location,opponent_location)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200) and Duel.GetCustomActivityCount(21400154,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(21400154,1-tp,ACTIVITY_CHAIN)>0 and Duel.IsExistingMatchingCard(c21400154.crmfil,tp,LOCATION_GRAVE,0,1,nil)
			end
end
function c21400154.ContactFusionTarget(filter,self_location,opponent_location)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				if #g>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					local tc=Duel.SelectMatchingCard(tp,c21400154.crmfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
					Duel.Remove(tc,POS_FACEUP,REASON_SPSUMMON)
					return true
				else return false end
			end
end
function c21400154.ContactFusionOperation(mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_MATERIAL+REASON_FUSION)
				g:DeleteGroup()
			end
end
function c21400154.plfilter(c)
	return c:IsSetCard(0x5211) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c21400154.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400154.plfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=2 end
end
function c21400154.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c21400154.plfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e2)
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e1) 
		end
	end
end
function c21400154.fumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_FUSION+REASON_MATERIAL==REASON_FUSION+REASON_MATERIAL and not c:IsReason(REASON_RETURN)
end 
function c21400154.tgfil(c) 
	return c:IsAbleToGrave() and c:IsCode(21400172) 
end 
function c21400154.thfil(c)  
	return c:IsAbleToHand() and c:IsSetCard(0x5211) 
end 
function c21400154.fumtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c21400154.tgfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) 
	local b2=Duel.IsExistingMatchingCard(c21400154.thfil,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end  
	e:SetLabel(0)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(21400154,1)},{b2,aux.Stringid(21400154,2)}) 
	e:SetLabel(op) 
	e:SetCategory(0)
	if op==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	end
	if op==2 then 
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c21400154.fumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local b1=Duel.IsExistingMatchingCard(c21400154.tgfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) 
	local b2=Duel.IsExistingMatchingCard(c21400154.thfil,tp,LOCATION_GRAVE,0,1,nil)
	local op=e:GetLabel() 
	if op==1 and b1 then 
		local sg=Duel.SelectMatchingCard(tp,c21400154.tgfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)  
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end 
	if op==2 and b2 then 
		local sg=Duel.SelectMatchingCard(tp,c21400154.thfil,tp,LOCATION_GRAVE,0,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end 
end 
function c21400154.ctrecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS) and e:GetHandler():IsType(TYPE_TRAP) and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end 
function c21400154.retgfil(c)
	return c:IsCode(21400172) and c:IsFaceup()
end
function c21400154.ctretg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c21400154.retgfil(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(c21400154.retgfil,tp,LOCATION_REMOVED,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c21400154.retgfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c21400154.ctreop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end 




