--克隆 皇帝
function c9990270.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c9990270.xyzcon)
	e1:SetOperation(c9990270.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9990270,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9990270)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9990270.negcon)
	e2:SetCost(c9990270.negcost)
	e2:SetTarget(c9990270.negtg)
	e2:SetOperation(c9990270.negop)
	c:RegisterEffect(e2)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c9990270.efilter)
	c:RegisterEffect(e5)
end
function c9990270.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x671) and c:IsCanBeXyzMaterial(xyzc)
end
function c9990270.xyzfilter1(c,g)
	return g:IsExists(c9990270.xyzfilter2,1,c,c:GetRank())
end
function c9990270.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c9990270.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c9990270.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c9990270.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and (not min or min<=2 and max>=2)
		and mg:IsExists(c9990270.xyzfilter1,1,nil,mg)
end
function c9990270.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	local sg=Group.CreateGroup()
	if og and not min then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=nil
		if og then
			mg=og:Filter(c9990270.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c9990270.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c9990270.xyzfilter1,1,1,nil,mg)
		local tc1=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c9990270.xyzfilter2,1,1,tc1,tc1:GetRank())
		local tc2=g2:GetFirst()
		g:Merge(g2)
		sg:Merge(tc1:GetOverlayGroup())
		sg:Merge(tc2:GetOverlayGroup())
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c9990270.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c9990270.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c9990270.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and e:GetLabelObject():IsSetCard(0x671) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function c9990270.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and e:GetLabelObject():IsSetCard(0x671) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9990270.efilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
--		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK)then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()>=6
		else
			return ec:GetOriginalLevel()>=6
		end
	else
			return false
	end
end