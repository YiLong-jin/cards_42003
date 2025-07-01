--幻星集的宝剑 编号III
function c65846653.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846653,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65846653)
	e1:SetTarget(c65846653.thtg)
	e1:SetOperation(c65846653.thop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846653,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65846653)
	e2:SetTarget(c65846653.thtg)
	e2:SetOperation(c65846653.thop)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c65846653.eftg1)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c65846653.eftg2)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
end
function c65846653.thfilter(c,ec,e,tp,chemck,chesck)
	return ((c:IsSetCard(0x3eb) or c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and chesck and not c:IsForbidden() or c:IsSetCard(0x3eb) and chemck and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function c65846653.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chemck=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local chesck=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846653.thfilter(chkc,e:GetHandler(),e,tp,chemck,chesck) end
	if chk==0 then return Duel.IsExistingTarget(c65846653.thfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler(),e,tp,chemck,chesck) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,c65846653.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler(),e,tp,chemck,chesck)
	if g:GetFirst():IsType(TYPE_MONSTER) then 
		e:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON) 
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c65846653.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local a=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b=(tc:CheckEquipTarget(e:GetHandler()) or tc:IsSetCard(0x3eb)) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsForbidden()
	if not tc:IsRelateToEffect(e) then return end
	if not a and not b then return end
	local op=aux.SelectFromOptions(tp,
			{a,aux.Stringid(65846653,1)},
			{b,aux.Stringid(65846653,2)})
			
	if op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		if Duel.Equip(tp,tc,e:GetHandler())==0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(e:GetHandler())
		e1:SetValue(c65846653.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c65846653.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c65846653.eftg1(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and not c:IsOriginalCodeRule(65846650) and not c:GetEquipGroup():IsExists(function(c) return  c:IsOriginalCodeRule(65846650) end,1,nil) 
end
function c65846653.eftg2(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and (c:GetEquipGroup():IsExists(function(c) return c:IsOriginalCodeRule(65846650) and not c:IsDisabled() end,1,nil) or c:IsOriginalCodeRule(65846650) and not c:IsDisabled())
end