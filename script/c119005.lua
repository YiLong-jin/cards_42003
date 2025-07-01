local m=119005
local cm=_G["c"..m]
cm.name="拟似驰龙"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.desfilter(c)
	return c:IsDestructable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then
		local h1=Duel.GetMatchingGroupCount(cm.desfilter,tp,LOCATION_HAND,0,nil)
		local h2=Duel.GetMatchingGroupCount(cm.desfilter,tp,0,LOCATION_HAND,nil)
		return h1>1 and h2>1
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local g1=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_HAND,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	local ac=Duel.SelectMatchingCard(1-tp,cm.desfilter,1-tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local bc=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if ac and bc then
		Duel.Destroy(Group.FromCards(ac,bc),REASON_EFFECT)
	end
end