--黑骑士小队-磨灭
function c9877698.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9877698.matfilter,2,true)

	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END) 
	e1:SetCondition(c9877698.rccon)
	e1:SetTarget(c9877698.rctg)
	e1:SetOperation(c9877698.rcop)
	c:RegisterEffect(e1)

	 local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(9877698,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9877698)
	e4:SetCost(c9877698.negcost)
	e4:SetCondition(c9877698.spcon1)
	e4:SetTarget(c9877698.tgtg1) 
	e4:SetOperation(c9877698.tgop1) 
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c9877698.spcon2)
	c:RegisterEffect(e5)
end
function c9877698.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877698.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877698.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFusionSetCard(0x17ec)
end

function c9877698.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end 
function c9877698.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c9877698.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local atk=e:GetHandler():GetAttack()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,atk,REASON_EFFECT)
end




function c9877698.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c9877698.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec)
end 
function c9877698.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end 
function c9877698.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877698.tgfil1,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c9877698.tgop1(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877698.tgfil1,tp,LOCATION_DECK,0,nil) 
	local g1=Duel.GetMatchingGroup(c9877698.spfil,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,sg)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,1500) and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877698,0))  then 
		Duel.PayLPCost(tp,1500)
		local xg=g1:Select(tp,1,1,nil) 
		Duel.SpecialSummon(xg,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
end