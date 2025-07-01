--斩魄妖梦
function c65846917.initial_effect(c)
	aux.AddMaterialCodeList(c,65846915)
	aux.AddCodeList(c,65846916)
	--synchro summon
	aux.AddSynchroProcedure(c,c65846917.tfilter,aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)--[[①效果]]
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65846917)
	e1:SetCondition(c65846917.thcon)
	e1:SetTarget(c65846917.thtg)
	e1:SetOperation(c65846917.thop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)--[[②效果]]
	e2:SetDescription(aux.Stringid(65846917,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65846917.setcon)
	e2:SetTarget(c65846917.settg)
	e2:SetOperation(c65846917.setop)
	c:RegisterEffect(e2)
end
function c65846917.tfilter(c)
	return c:IsCode(65846915)
end
----------------------------------------------------把卡回手效果
function c65846917.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65846917.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c) return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand() end,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65846917.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand() end,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
----------------------------------------------------把卡盖放效果
function c65846917.setcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ((ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function c65846917.setfilter(c)
	return c:IsType(0x4) and c:IsSSetable() and aux.IsCodeListed(c,65846916)
end
function c65846917.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846917.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(tp,65846917)==0 end
	Duel.RegisterFlagEffect(tp,65846917,RESET_PHASE+PHASE_END,0,1)
end
function c65846917.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65846917.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SSet(tp,g:GetFirst())~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(65846917,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		--g:GetFirst():RegisterEffect(e1)
	end
end