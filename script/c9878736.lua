--魔法少女VS系列？
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

function cm.initial_effect(c)
	aux.AddCodeList(c,9878730,42624039)
	--des
	local e1=Effect.CreateEffect(c)
	e1:SetCTCRPC(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND,"eta",EVENT_FREE_CHAIN,nil,nil)
	e1:SetCCTO(nil,nil,cm.thtg,cm.thop)
	c:RegisterEffect(e1)
	--des
	local e7=Effect.CreateEffect(c)
	e7:SetCTCRPC(CATEGORY_ATKCHANGE,"eti",nil,0x10,0x00010,1,m)
	e7:SetCCTO(nil,aux.bfgcost,cm.sptg,cm.spop)
	c:RegisterEffect(e7)
end

function cm.tgtfilter(c)
	return (c:IsCodeListed(42624039) or c.Majo) and (c:IsType(0x1) or c:IsLocation(0x04))
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,0x06,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x17)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.optfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c.Majo or c.Dopple or c:IsCode(99900310，99900320,99900340))
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dc=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0x06,0,1,1,nil):GetFirst()
	if dc then
		if dc:IsLocation(0x04) then Duel.HintSelection(Group.FromCards(dc)) end
		if Duel.Destroy(dc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local b1=aux.mzctcheck(nil,tp) and Duel.IsExistingMatchingCard(mR.SpSummonFilter(Card.IsCode),tp,0x01,0,1,nil,e,0,tp,false,false,9878730)
			local b2=Duel.IsExistingMatchingCard(mR.ToHandFilter(mR.MajoCheck(Card.IsType)),tp,0x01,0,1,nil,0x1)
			local b3=aux.mzctcheck(nil,tp) and Duel.IsExistingMatchingCard(cm.optfilter,tp,0x12,0,1,nil,e,tp)
			local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)},{b3,aux.Stringid(m,2)})
			if not op then return false end
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,mR.SpSummonFilter(Card.IsCode),tp,0x01,0,1,1,nil,e,0,tp,false,false,9878730)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			elseif op==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,mR.ToHandFilter(mR.MajoCheck(Card.IsType)),tp,0x01,0,1,1,nil,0x1)
				if #g>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			elseif op==3 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.optfilter,tp,0x12,0,1,1,nil,e,tp)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		end
	end
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:Chkc(tp,0x04,mR.FaceupFilter(Card.IsCode),9878730) end
	if chk==0 then return Duel.IsExistingTarget(mR.FaceupFilter(Card.IsCode),tp,0x04,0,1,nil,9878730) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,mR.FaceupFilter(Card.IsCode),tp,0x04,0,1,1,nil,9878730)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		tc:AtkDefSingleUpdate(EFFECT_SET_ATTACK,tc:GetAttack()*1.5,e:GetHandler(),nil)
	end
end