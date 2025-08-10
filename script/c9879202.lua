--鲑鱼子九霄-救世主装甲
function c9879202.initial_effect(c)
	aux.AddXyzProcedure(c,nil,10,5,nil,nil,99)
	c:EnableReviveLimit() 

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end)
	c:RegisterEffect(e1) 


	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_LPCOST_CHANGE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(1,1)
	e11:SetValue(c9879202.costchange)
	c:RegisterEffect(e11) 

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879202,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9879202.copycost)
	e3:SetTarget(c9879202.copytg)
	e3:SetOperation(c9879202.copyop)
	c:RegisterEffect(e3)
end
function c9879202.costchange(e,re,rp,val)
	if re then 
		return 0
	else return val end
end


function c9879202.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c9879202.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9879202)==0 and c:CheckRemoveOverlayCard(tp,3,REASON_COST) end
	c:RemoveOverlayCard(tp,3,3,REASON_COST)
	c:RegisterFlagEffect(9879202,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9879202.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9879202.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9879202.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9879202.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c9879202.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetBaseAttack()
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end