--爆诞的崩界王
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.EnableUnionAttribute(c,cm.filter)
 --sp1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(EFFECT_TYPE_EQUIP+CATEGORY_DESTROY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	--draw1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0x37a2)
end

function cm.ffilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x37a2) and c:IsFaceup()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if  chkc then return Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.ffilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_GRAVE,0,2,nil,e,tp)  end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,cm.ffilter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
		 if #sg>1 then 
		 for ec in aux.Next(sg) do 
	   if not Duel.Equip(tp,ec,tc) then return end
			  Duel.Destroy(c,REASON_EFFECT)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(cm.eqlimit)
		ec:RegisterEffect(e1)
		 end
end
	end
  end   
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function cm.cfilter(c,tp,rp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and rp==1-tp and c:IsReason(REASON_EFFECT)and c:IsSetCard(0x37a2)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
