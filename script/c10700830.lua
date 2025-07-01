--刹那芳华 百织夜行
function c10700830.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,nil,nil,nil,nil,1,99,c10700830.scheck)
	c:EnableReviveLimit()
	--use baseattack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e0:SetCondition(c10700830.atkcon)
	e0:SetOperation(c10700830.atkop)
	c:RegisterEffect(e0) 
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c10700830.sumsuc)
	c:RegisterEffect(e1)	
	--disable and destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c10700830.disop)
	c:RegisterEffect(e2)
	--spirit return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c10700830.retreg)
	c:RegisterEffect(e4) 
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10700830,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(c10700830.thcon)
	e6:SetTarget(c10700830.thtg)
	e6:SetOperation(c10700830.thop)
	c:RegisterEffect(e6)
end
c10700830.material_type=TYPE_SYNCHRO 
function c10700830.scheck(g,lc)
	return g:IsExists(Card.IsSynchroType,1,nil,TYPE_SYNCHRO)
end
function c10700830.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c or Duel.GetAttackTarget()==c
end
function c10700830.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(c:GetBaseAttack())
	c:RegisterEffect(e1)
end
function c10700830.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsPlayerCanDraw(tp,1) then
		ops[off]=aux.Stringid(10700830,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
		ops[off]=aux.Stringid(10700830,1)
		opval[off-1]=2
		off=off+1
	end
	if ((h1<h2 and Duel.IsPlayerCanDraw(tp,h2-h1)) or h1>h2) and c:IsAttack(0) then
		ops[off]=aux.Stringid(10700830,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
	Duel.Draw(tp,1,REASON_EFFECT)
	elseif opval[op]==2 then
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	elseif opval[op]==3 then
	   if h1<h2 and Duel.IsPlayerCanDraw(tp,h2-h1) then
		   Duel.Draw(tp,h2-h1,REASON_EFFECT)
	   end
	   if h1>h2 then
		   Duel.DiscardHand(tp,nil,h1-h2,h1-h2,REASON_EFFECT+REASON_DISCARD)
	   end
	end
end
function c10700830.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then return end
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10700830.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c10700830.retcon)
	e1:SetTarget(c10700830.rettg)
	e1:SetOperation(c10700830.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c10700830.retcon2)
	e2:SetTarget(c10700830.rettg2)
	c:RegisterEffect(e2)
end
function c10700830.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700830.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700830.thfilter(c)
	return c:IsSetCard(0x7cc) and c:IsAbleToHand()
end
function c10700830.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,10700738) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700830.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700830,4)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end
function c10700830.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700830.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700830.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700830.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():GetFlagEffect(10700831)==0 end
	e:GetHandler():RegisterFlagEffect(10700831,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700830.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700830.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700830,4)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end