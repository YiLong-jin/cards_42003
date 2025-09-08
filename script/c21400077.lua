--恐虐血饮魔·斯卡布兰德
function c21400077.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,21400077)
	e1:SetCondition(c21400077.hspcon)
	e1:SetTarget(c21400077.hsptg)
	e1:SetOperation(c21400077.hspop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11400077)
	e2:SetCondition(c21400077.spcon)
	e2:SetCost(c21400077.spcost)
	e2:SetTarget(c21400077.sptg)
	e2:SetOperation(c21400077.spop)
	c:RegisterEffect(e2)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c21400077.discon1)
	e2:SetOperation(c21400077.disop1)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c21400077.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
	if not c21400077.global_check then
		c21400077.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED) 
		ge1:SetOperation(c21400077.regop)
		Duel.RegisterEffect(ge1,0)
	end
end  
function c21400077.regop(e,tp,eg,ep,ev,re,r,rp) 
	if eg:IsExists(Card.IsPreviousControler,1,nil,0) then
		Duel.RegisterFlagEffect(0,21400077,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	if eg:IsExists(Card.IsPreviousControler,1,nil,1) then
		Duel.RegisterFlagEffect(1,21400077,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c21400077.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,21400077)~=0 
end
function c21400077.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400077.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21400077.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c21400077.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c21400077.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x6210)  
end 
function c21400077.spgck(g,e,tp) 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and g:GetCount()>1 then return false end 
	return g:GetCount()<=Duel.GetMZoneCount(tp,e:GetHandler()) and g:GetSum(Card.GetLevel)<=8   
end 
function c21400077.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c21400077.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c21400077.spgck,1,5,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21400077.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21400077.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if g:CheckSubGroup(c21400077.spgck,1,5,e,tp) then 
		local sg=g:SelectSubGroup(tp,c21400077.spgck,false,1,5,e,tp)
		for tc in aux.Next(sg) do 
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetTarget(c21400077.splimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end 
		Duel.SpecialSummonComplete()
	end
end
function c21400077.splimit(e,c)
	return not c:IsSetCard(0x6210)
end
function c21400077.discon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and c:GetBattleTarget()
end
function c21400077.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	tc:RegisterFlagEffect(21400078,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.AdjustInstantly(c)
end
function c21400077.distg(e,c)
	return c:GetFlagEffect(21400078)~=0
end


