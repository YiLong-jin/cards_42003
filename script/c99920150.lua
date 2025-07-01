--黑晶龙 剑龙
local cm,m,o=GetID()
cm = cm or {}
function cm.LS(c,code,att,cat,tg,op)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,code)
	e1:SetCondition(cm.LS_con1(att))   
	e1:SetTarget(cm.LS_tg1)
	e1:SetOperation(cm.LS_op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(cat)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,code+1)
	e2:SetTarget(tg)
	e2:SetOperation(op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	return e1,e2,e3
end
function cm.LS_con1(att)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):Filter(Card.IsCode,nil,0x6661):IsExists(Card.IsAttribute,1,nil,att)   
	end
end
function cm.LS_tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.LS_op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) 
end
if not cm then return end
--------------------------------------------------------
function cm.initial_effect(c)
	local e1={cm.LS(c,m,ATTRIBUTE_WATER,CATEGORY_SPECIAL_SUMMON,cm.tg,cm.op)}
end
function cm.tgf(c,e,tp,att)
	if not (c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER)) then return false end
	return Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetAttribute(),att) 
end
function cm.tgf2(c,e,tp,att,chk)
	if not (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER)) then return false end
	return (not chk and c:IsAttribute(att)) or (c:IsPublic() and c:IsAttribute(chk))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		local att=e:GetLabel()
		return cm.tgf(chkc,e,tp,att) and chkc:IsControler(tp) 
	end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.tgf,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	e:SetLabel(tc:GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local v=Duel.GetFirstTarget()
	if not v:IsRelateToEffect(e) then return end
	v=Duel.GetMatchingGroup(cm.tgf2,tp,LOCATION_HAND,0,nil,e,tp,v:GetAttribute())
	if #v==0 then return end
	Duel.SpecialSummon(v:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP) 
end