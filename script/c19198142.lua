--星慧之大贤者 桑德里永
function c19198142.initial_effect(c)
 --xyz summon
	aux.AddXyzProcedure(c,c19198142.xyzfilter,4,2,c19198142.ovfilter,aux.Stringid(19198142,0),2,c19198142.xyzop)
	c:EnableReviveLimit()   
--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c19198142.atkval)
	c:RegisterEffect(e2)
--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(c19198142.defval)
	c:RegisterEffect(e3)
--to deck
--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19198142,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(2,19198142)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c19198142.cost)
	e1:SetTarget(c19198142.target)
	e1:SetOperation(c19198142.operation)
	c:RegisterEffect(e1)
end
--xyz summon 
function c19198142.xyzfilter(c)
	return Duel.GetFlagEffect(c:GetControler(),19198142)==0 and c:IsSetCard(0x150)
end
function c19198142.cfilter(c)
	return (c:IsSetCard(0x150) or c:IsSetCard(0x106e)) and c:IsAbleToGraveAsCost()
end
function c19198142.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x150) and(c:IsType(TYPE_FUSION)or c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK))
end
function c19198142.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198142.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c19198142.cfilter,1,1,REASON_COST,nil)
	e:GetHandler():RegisterFlagEffect(19198142,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
--atk up
function c19198142.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*100
end
--def up
function c19198142.defval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*100
end
--to deck
function c19198142.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c19198142.filter1(c)
	return c:IsLocation(LOCATION_GRAVE)  and c:IsSetCard(0x150,0x106e) and c:IsAbleToDeck()
end
function c19198142.filter2(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_ONFIELD)) and c:IsAbleToDeck()
end
function c19198142.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetHandler():GetFlagEffect(19198142)==0  and Duel.IsExistingTarget(c19198142.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c19198142.filter2,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c19198142.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c19198142.filter2,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c19198142.filter3(c,e)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_ONFIELD)) and c:IsRelateToEffect(e)
end
function c19198142.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c19198142.filter3,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end