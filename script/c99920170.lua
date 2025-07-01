--雷晶龙 翅龙
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c99920150") end) then require("script/c99920150") end
function cm.initial_effect(c)
	local e1={cm.LS(c,m,ATTRIBUTE_FIRE,CATEGORY_TOHAND,cm.tg,cm.op)}
end
function cm.tgf(c)
	return c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetAttribute()) and c:IsFaceup()
end
function cm.tgf2(c,att)
	return c:IsAbleToHand() and c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER) and c:IsAttribute(att) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.tgf(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tgf,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local v=Duel.GetFirstTarget()
	if not v:IsRelateToEffect(e) or v:IsFacedown() then return end
	v=Duel.SelectMatchingCard(cm.tgf2,tp,LOCATION_REMOVED,0,nil,v:GetAttribute()):GetFirst()
	if not v then return end
	Duel.SendtoHand(v,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,v)
end