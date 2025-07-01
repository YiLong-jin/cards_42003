--大御神 天照
function c10701016.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701016,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10701016)
	e1:SetCondition(c10701016.drcon)
	e1:SetTarget(c10701016.drtg)
	e1:SetOperation(c10701016.drop)
	c:RegisterEffect(e1)   
	--spirit return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c10701016.retreg)
	c:RegisterEffect(e4) 
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10701016,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCountLimit(1,10701017)
	e6:SetCondition(c10701016.spcon)
	e6:SetTarget(c10701016.sptg)
	e6:SetOperation(c10701016.spop)
	c:RegisterEffect(e6) 
end
function c10701016.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c10701016.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10701016.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,10701015,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
end
function c10701016.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10701017)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c10701016.retcon)
	e1:SetTarget(c10701016.rettg)
	e1:SetOperation(c10701016.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c10701016.retcon2)
	e2:SetTarget(c10701016.rettg2)
	c:RegisterEffect(e2)
end
function c10701016.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and Duel.GetFlagEffect(tp,10701015)==0
end
function c10701016.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10701016.spfilter(c,e,tp)
	return c:IsCode(10701019) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701016.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,10701015)~=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(c10701016.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701016,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		 end
	end
end
function c10701016.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and Duel.GetFlagEffect(tp,10701015)~=0
end
function c10701016.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10701016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10701015)~=0
end
function c10701016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetFlagEffect(tp,10701015)~=0 end
	e:GetHandler():RegisterFlagEffect(10700744,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10701016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(c10701016.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701016,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		 end
	end
end