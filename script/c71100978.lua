-- 理趣螺旋的时钟器械
local this,id,ofs=GetID()
function this.initial_effect(c)
	aux.AddCodeList(c,71100982)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1)
	e6:SetCondition(this.remcon)
	e6:SetTarget(this.remtg)
	e6:SetOperation(this.remop)
	c:RegisterEffect(e6)
	--damage 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(this.damcon)
	e4:SetValue(this.damval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
end
function this.mschk(c)
	return c:IsCode(71100982) and c:IsFaceup()
end
function this.filter(c,tp)
	if Duel.IsExistingMatchingCard(this.mschk,tp,LOCATION_ONFIELD,0,1,nil,71100982) and c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,71100982) and c:IsAbleToHand() and c:IsFaceupEx() then 
		return true
	end
	return c:IsCode(71100982) and c:IsAbleToHand() and c:IsFaceupEx()
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(this.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function this.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function this.remcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(this.cfilter,1,nil)
end
function this.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function this.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end
function this.damcon(e)
	return Duel.GetFieldGroupCount(e:GetOwnerPlayer(),LOCATION_MZONE,0)<1
end
function this.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
