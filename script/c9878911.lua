--银的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=023
function cm.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"eti",nil,0x02,nil,1,m)
	e2:SetCCTO(nil,cm.spcost,cm.sptg,cm.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCTCRPC(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON,"etqo",EVENT_FREE_CHAIN,0x04,nil,1,m*10)
	e3:SetCCTO(cm.spcon,nil,cm.sptg2,cm.spop2)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.geop)
		Duel.RegisterEffect(ge1,0)
	end
end

function cm.geop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(rp,m)~=0 then
		Duel.SetFlagEffectLabel(rp,m,Duel.GetFlagEffectLabel(rp,m)+1)
	else
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1,1)
	end
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
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local g=Duel.GetMatchingGroup(mR.FaceupFilter(mR.MajoCheck()),tp,0x04,0,nil)
			if e:GetLabel()==1 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				for tc in aux.Next(g) do
					tc:AtkDefSingleUpdate(EFFECT_UPDATE_ATTACK,500,c)
				end
			end
		end
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,m)~=0 and Duel.GetFlagEffectLabel(1-tp,m)>=5
end

function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(mR.ToHandFilter(mR.IsTypeFilter(mR.MajoCheck())),tp,0x10,0,1,nil,0x1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
end

function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local gc=Duel.SelectMatchingCard(tp,mR.ToHandFilter(mR.IsTypeFilter(mR.MajoCheck())),tp,0x10,0,1,1,nil,0x1):GetFirst()
	if gc and gc:RTOHANDsolve(tp) then
		Duel.BreakEffect()
		if gc:IsCanBeSpecialSummoned(e,0,tp,true,false) and aux.mzctcheck(nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.SpecialSummon(gc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end