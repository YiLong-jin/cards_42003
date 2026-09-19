--蔷薇的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=010
function cm.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"eti",nil,0x02,nil,1,m)
	e2:SetCCTO(nil,cm.spcost,cm.sptg,cm.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCTCRPC(CATEGORY_TOHAND+CATEGORY_SEARCH,"etto+s",EVENT_SUMMON_SUCCESS,nil,0x10000,1,m*10)
	e3:SetCCTO(nil,nil,cm.thtg,cm.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
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
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetRange(LOCATION_MZONE)
				e2:SetValue(1)
				c:RegisterEffect(e2,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(mR.IsTypeFilter(mR.ToHandFilter(mR.MajoCheck(Card.IsLevelBelow))),tp,0x01,0,1,nil,0x1,6) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,mR.IsTypeFilter(mR.ToHandFilter(mR.MajoCheck(Card.IsLevelBelow))),tp,0x01,0,1,1,nil,0x1,6)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c.Majo and c:IsLocation(0x12)
end