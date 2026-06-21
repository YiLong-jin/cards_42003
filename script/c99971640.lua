--城堡创造物
local s, id = GetID()
function c99971640.initial_effect(c)
	aux.AddFusionProcCode2(c,99971670,{99971660,99971670},true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,Duel.Remove,POS_FACEUP,REASON_COST)	
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c99971640.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99971640,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,99971640)
	e1:SetTarget(c99971640.thtg)
	e1:SetOperation(c99971640.thop)
	c:RegisterEffect(e1)
	
	 -- 效果⑨：装备怪兽不会被战斗破坏（从e9开始）
	local e9=Effect.CreateEffect(c)  -- 改为e9
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e9:SetValue(1)
	c:RegisterEffect(e9)  -- 注册e9
end
function c99971640.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c99971640.thfilter(c)
	return c:IsCode(99971670) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c99971640.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971640.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c99971640.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99971640.thfilter),tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end