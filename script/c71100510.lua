--终结技·流星核爆裂
local s,id,ofs=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(s.desdcon)
	e1:SetTarget(s.desdtg)
	e1:SetOperation(s.desdop)
	c:RegisterEffect(e1)
	--MoveToPzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.condtion)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	e2:SetValue(s.zones)
	c:RegisterEffect(e2)
end
function s.desdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.desdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if Duel.IsExistingMatchingCard(s.checkf,tp,LOCATION_MZONE,0,1,nil) then 
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetSum(Card.GetBaseDefense))
	end 
end
function s.checkf(c)
	return c:IsFaceup() and c:IsSetCard(0x37d0) 
end
function s.desdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and Duel.IsExistingMatchingCard(s.checkf,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		local og=Duel.GetOperatedGroup()
		Duel.Damage(1-tp,og:GetSum(Card.GetBaseDefense),REASON_EFFECT)
	end
end
function s.condtion(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:GetFirst()==e:GetHandler() and e:GetHandler():IsReason(REASON_EFFECT)
end
function s.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	if not b or p0 and p1 then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function s.penfilter(c)
	return c:IsCode(71100500) and c:IsType(TYPE_PENDULUM)
		and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
