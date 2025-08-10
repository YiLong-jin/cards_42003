--黑骑士小队-毁灭
function c9877627.initial_effect(c)
	 aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x17ec),4,2)
	c:EnableReviveLimit()

	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877627)
	e3:SetCost(c9877627.cost1)
	e3:SetCondition(c9877627.spcon1)
	e3:SetTarget(c9877627.destg)
	e3:SetOperation(c9877627.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877627.spcon2)
	c:RegisterEffect(e4)
	
	
end
function c9877627.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877627.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877627.spfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0x17ec)
end 
function c9877627.spfil1(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end 
function c9877627.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9877627.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9877627.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c9877627.spfil1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c9877627.spfil,tp,LOCATION_SZONE,0,nil,e,tp)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,2000) and g1:GetCount()>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877627,0)) then
		Duel.PayLPCost(tp,2000)
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end