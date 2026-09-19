--双重镭射机甲铠
function c10701905.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c10701905.target)
	e1:SetOperation(c10701905.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetTarget(c10701905.distg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c10701905.atkval)
	c:RegisterEffect(e3)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c10701905.eqlimit)
	c:RegisterEffect(e4)   
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10701905,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10701905)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c10701905.destg)
	e5:SetOperation(c10701905.desop)
	c:RegisterEffect(e5) 
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,10701906)
	e6:SetCondition(c10701905.tdcon)
	e6:SetCost(c10701905.tdcost)
	e6:SetTarget(c10701905.tdtg)
	e6:SetOperation(c10701905.tdop)
	c:RegisterEffect(e6)
end
function c10701905.eqlimit(e,c)
	return c:IsRace(RACE_INSECT)
end
function c10701905.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c10701905.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10701905.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701905.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10701905.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10701905.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c10701905.distg(e,c)
	local handler=e:GetHandler()
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and handler:GetColumnGroup():IsContains(c)
end
function c10701905.atkval(e,c)
	local handler=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local cg=handler:GetColumnGroup()
	if #cg==0 then return 0 end 
	local atk_sum=0
	local g=cg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsType,nil,TYPE_MONSTER)   
	local tc=g:GetFirst()
	while tc do
		local batk=tc:GetBaseAttack()
		if batk>0 then
			atk_sum=atk_sum+batk
		end
		tc=g:GetNext()
	end
	return math.floor(atk_sum/2)
end
function c10701905.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10701905.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10701905.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10701905.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function c10701905.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701905.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10701905.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10701905.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10701905.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local opt=Duel.SelectOption(tp,aux.Stringid(10701905,2),aux.Stringid(10701905,3))
		Duel.SendtoDeck(e:GetHandler(),nil,opt,REASON_EFFECT)
	end
end