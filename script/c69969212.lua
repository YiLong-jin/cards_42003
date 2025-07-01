--交响曲·卡门
function c69969212.initial_effect(c)
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(69969212,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,69969212) 
	e1:SetCondition(function(e) 
	return e:GetLabel()==1 end)
	e1:SetTarget(c69969212.thtg) 
	e1:SetOperation(c69969212.thop) 
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_LEAVE_FIELD_P)  
	e2:SetOperation(c69969212.thckop) 
	e2:SetLabelObject(e1) 
	c:RegisterEffect(e2) 
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969212,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1,69969223) 
	e3:SetTarget(c69969212.eqtg)
	e3:SetOperation(c69969212.eqop)
	c:RegisterEffect(e3)
end
function c69969212.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c69969212.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 
function c69969212.thckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget() 
	if ec==nil and c:IsHasEffect(EFFECT_EQUIP_LIMIT) then 
	e:GetLabelObject():SetLabel(1)
	else e:GetLabelObject():SetLabel(0) end 
end 
function c69969212.filter(c)
	return c:IsFaceup()  
end
function c69969212.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c69969212.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c69969212.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c69969212.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if Duel.Equip(tp,c,tc) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		c:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCountLimit(1)
		e2:SetTarget(c69969212.xsetg)
		e2:SetOperation(c69969212.xseop)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(function(e,c)
		return e:GetHandler():GetEquipTarget()==c end)
		e3:SetLabelObject(e2)
		c:RegisterEffect(e3)
	end 
end
function c69969212.espfil(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x69b) and e:GetHandler():GetEquipGroup():IsContains(c)   
end 
function c69969212.xsetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c69969212.espfil,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c69969212.espfil,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end 
function c69969212.xseop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then 
		if Duel.Equip(tp,c,tc) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			c:RegisterEffect(e1)   
		end  
	end 
end 









