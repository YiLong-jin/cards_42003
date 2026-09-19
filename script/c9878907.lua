--涂鸦的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=160
function cm.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"eti",nil,0x02,nil,1,m)
	e2:SetCCTO(nil,cm.spcost,cm.sptg,cm.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCTCRPC(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND,"etqo",EVENT_FREE_CHAIN,0x04,nil,1,m*10)
	e3:SetCCTO(cm.spcon,nil,cm.sptg2,cm.spop2)
	c:RegisterEffect(e3)
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(mR.IsRaceFilter(mR.Mzctcheck(Card.IsReleasable)),tp,0x04,0,nil,RACE_SPELLCASTER,tp)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0x04,0)==0 or #g>0 end
	if Duel.GetFieldGroupCount(tp,0x04,0)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=g:Select(tp,1,1,nil)
		Duel.Release(g,REASON_COST)
		e:SetLabel(1)
	end
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.GetMZoneCount(tp)>0 then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if e:GetLabel()==1 then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(m,0))
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e2:SetRange(LOCATION_MZONE)
				e2:SetValue(1)
				c:RegisterEffect(e2,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(mR.SpSummonFilter(mR.MajoCheck()),tp,0x12,0,1,nil,e,0,tp,false,false) and e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x12)
end

function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if aux.mzctcheck(nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,mR.SpSummonFilter(mR.MajoCheck()),tp,0x12,0,1,1,nil,e,0,tp,false,false)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local c=e:GetHandler()
			if c:IsRelateToChain() then
				Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEDOWN))
			e1:SetValue(cm.efilter)
			e1:SetReset(RESET_PHASE+PHASE_MAIN2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end