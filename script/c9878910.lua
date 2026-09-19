--箱子的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=062
function cm.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"eti",nil,0x02,nil,1,m)
	e2:SetCCTO(nil,cm.spcost,cm.sptg,cm.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCTCRPC(CATEGORY_DRAW+CATEGORY_TOHAND,"etto+f",EVENT_RELEASE,0x04,0x10000,1,m*10)
	e3:SetCCTO(cm.spcon,nil,cm.sptg2,cm.spop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
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
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0x01)
	end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.GetMZoneCount(tp)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if e:GetLabel()==1 and aux.mzctcheck(nil,tp) and Duel.IsExistingMatchingCard(mR.IsTypeFilter(mR.MajoCheck(Card.IsCanBeSpecialSummoned)),tp,0x01,0,1,nil,0x1,e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,mR.IsTypeFilter(mR.MajoCheck(Card.IsCanBeSpecialSummoned)),tp,0x01,0,1,1,nil,0x1,e,0,tp,false,false)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(mR.IsTypeFilter(mR.MajoCheck(Card.IsPreviousLocation)),1,nil,0x1,0x0e)
end

function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT) then
		Duel.BreakEffect()
		local n=Duel.GetMatchingGroupCount(mR.FaceupFilter(mR.MajoCheck()),tp,0x04,0,nil)
		if n>0 and Duel.IsExistingMatchingCard(mR.ToHandFilter(mR.MajoCheck(Card.IsType)),tp,0x10,0,1,nil,0x1) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,mR.ToHandFilter(mR.MajoCheck(Card.IsType)),tp,0x10,0,1,n,nil,0x1)
			if #g>0 then
				g:RTOHANDsolve(tp)
			end
		end
	end
end