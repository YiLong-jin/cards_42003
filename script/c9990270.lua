--克隆 皇帝
function c9990270.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c9990270.mfilter1,c9990270.xyzcheck1,2,2) 
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
function c9990270.mfilter1(c,xyzc)
	local tp=c:GetControler()
	return (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_LINK)) and c:IsSetCard(0x671)
end
function c9990270.xyzcheck1(g)
	return true 
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