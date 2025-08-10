--黑骑士小队-幻灭
function c9877613.initial_effect(c)
	 aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x17ec),4,2)
	c:EnableReviveLimit() 
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c9877613.actcon)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877613)
	e3:SetCost(c9877613.cost1)
	e3:SetCondition(c9877613.spcon1)
	e3:SetTarget(c9877613.destg)
	e3:SetOperation(c9877613.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877613.spcon2)
	c:RegisterEffect(e4)
	
end
function c9877613.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877613.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877613.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end


function c9877613.spfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0x17ec)
end 
function c9877613.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end 
function c9877613.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9877613.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c9877613.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g1=Duel.GetMatchingGroup(c9877613.spfil,tp,LOCATION_SZONE,0,nil,e,tp)
	local g=Duel.GetMatchingGroup(c9877613.tgfil1,tp,LOCATION_GRAVE,0,nil) 
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and g:GetCount()>0 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877613,0)) then
		Duel.Recover(p,d,REASON_EFFECT)
		local sg=g:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg)
	end
end