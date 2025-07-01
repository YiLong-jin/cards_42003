--制裁者 复活圣女·卢克蕾西亚
function c9990640.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c9990640.matfilter,2,2)
	c:EnableReviveLimit()
	--level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,9990640)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c9990640.lvcost)
	e4:SetOperation(c9990640.lvop)
	c:RegisterEffect(e4)
end
function c9990640.matfilter(c)
	return c:IsSetCard(0x671)
end
function c9990640.costfilter(c,lv)
	return c:IsLevelAbove(1) and c:IsSetCard(0x671) and c:IsAbleToGraveAsCost()
end
function c9990640.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c9990640.costfilter,tp,LOCATION_DECK,0,1,nil,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9990640.costfilter,tp,LOCATION_DECK,0,1,1,nil,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c9990640.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
	end
end