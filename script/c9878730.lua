--阿莉娜·格雷
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

function cm.initial_effect(c)
	aux.AddCodeList(c,m,42624039)
	--des
	local e4=Effect.CreateEffect(c)
	e4:SetCTCRPC(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON,"eti",nil,0x06,0x00010,1,m)
	e4:SetCCTO(nil,nil,cm.destg,cm.desop)
	c:RegisterEffect(e4)
	--des
	local e7=Effect.CreateEffect(c)
	e7:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"etto+s",EVENT_DESTROYED,nil,0x10000,1,m)
	e7:SetCCTO(cm.spcon,nil,cm.sptg2,cm.spop2)
	c:RegisterEffect(e7)
	cm.Magius_DesEffect=e7
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0x04,0,1,nil,m) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0x04,0,1,1,nil,m)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x12)
end

function cm.opsfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c.Majo or c.Dopple or c:IsCode(99900310，99900320,99900340))
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ck=tc:IsCodeListed(42624039)
	if tc:IsRelateToChain() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if aux.mzctcheck(nil,tp) and Duel.IsExistingMatchingCard(cm.opsfilter,tp,0x12,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.opsfilter,tp,0x12,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
			end
		end
		local c=e:GetHandler()
		if ck and c:IsRelateToChain() and c:IsLocation(0x02) and aux.mzctcheck(nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end

function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.mzctcheck(nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		return true
	end
	return false
end