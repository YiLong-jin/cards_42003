--夏日恋情·情怀
function c9879381.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,nil,c9879381.lcheck)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	--c:RegisterEffect(e1)
	
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_CONTROL)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,9879381)
	e11:SetCost(c9879381.rccost)
	e11:SetTarget(c9879381.potg)
	e11:SetOperation(c9879381.poop)
	c:RegisterEffect(e11)
end
function c9879381.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end



function c9879381.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9879381.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879381.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9879381.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9879381.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end

function c9879381.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c9879381.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function c9879381.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end