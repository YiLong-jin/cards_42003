--革命组件:破片飞翼
local m=71100250
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3019642,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSetCard(0x7da) and c:IsAbleToGraveAsCost()
end
function cm.f2(c)
	return c:IsPosition(POS_ATTACK) and c:IsCanChangePosition() 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,c)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.f2,tp,0,LOCATION_MZONE,1,nil) and #cg>0 and c:IsSetCard(0x7da) and c:IsAbleToGraveAsCost() and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cog=cg:Select(tp,1,1,nil)
	cog:AddCard(c)
	Duel.SendtoGrave(cog,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.f2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then 
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end