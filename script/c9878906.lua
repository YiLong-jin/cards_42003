--蔷薇的魔女
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

cm.Majo=true
mR.MajoID[m]=011
function cm.initial_effect(c)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCTCRPC(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE,"etto+s",EVENT_SUMMON_SUCCESS,nil,0x10000,1,m*10)
	e3:SetCCTO(nil,nil,cm.thtg,cm.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND,"etqo",EVENT_FREE_CHAIN,0x04,nil,1,m)
	e2:SetCCTO(nil,cm.spcost,cm.sptg,cm.spop)
	c:RegisterEffect(e2)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(mR.ToGraveFilter(mR.MajoCheck(Card.IsType)),tp,0x01,0,1,nil,0x1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
end

function cm.opcfilter(c,tc)
	return c:IsAbleToHand() and c:IsType(0x1) and tc:IsCodeListed(c:GetCode())
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,mR.ToGraveFilter(mR.MajoCheck(Card.IsType)),tp,0x01,0,1,1,nil,0x1):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if tc:IsLocation(0x10) and Duel.IsExistingMatchingCard(cm.opcfilter,tp,0x01,0,1,nil,tc) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.opcfilter,tp,0x01,0,1,1,nil,tc)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Release(c,REASON_COST)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(mR.IsRaceFilter(Card.IsCanBeSpecialSummoned),tp,0x02,0,1,nil,RACE_SPELLCASTER,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.mzctcheck(nil,tp) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,mR.IsRaceFilter(Card.IsCanBeSpecialSummoned),tp,0x02,0,1,1,nil,RACE_SPELLCASTER,e,0,tp,false,false):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		if Duel.SpecialSummonComplete()~=0 then
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(mR.ToHandFilter(mR.MajoCheck(Card.IsType)),tp,0x10,0,1,nil,0x1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local g=Duel.SelectMatchingCard(tp,mR.ToHandFilter(mR.MajoCheck(Card.IsType)),tp,0x10,0,1,1,nil,0x1)
				if #g>0 then
					g:RTOHANDsolve(tp)
				end
			end
		end
	end
end