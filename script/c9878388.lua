--直到抵达星星那天
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

function cm.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCTCRPC(CATEGORY_SPECIAL_SUMMON,"eta",EVENT_CHAINING,nil,nil,1,m)
	e1:SetCCTO(cm.spcon,nil,cm.sptg,cm.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(nil,"etqo",EVENT_FREE_CHAIN,0x10,nil,1,m)
	e2:SetCCTO(nil,aux.bfgcost,cm.immtg,cm.immop)
	c:RegisterEffect(e2)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(mR.FaceupFilter(Card.IsCodeListed),tp,0x04,0,1,nil,9877918)
end

function cm.tgsfilter(c,e,tp)
	return c:IsCodeListed(9877918) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
	((c:IsLocation(0x30) and c:IsFaceup() and aux.mzctcheck(nil,tp)) or (c:IsLocation(0x40) and Duel.GetLocationCountFromEx(tp,tp,nil,c))>0)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x70,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x70)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x70,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function cm.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(mR.FaceupFilter(Card.IsCode),tp,0x04,0,1,nil,9877873,9877918) end
end

function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(0x6)
end

function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(Duel.GetMatchingGroup(mR.FaceupFilter(Card.IsCode),tp,0x04,0,nil,9877873,9877918)) do
		e:GetHandler():ImmGiven(aux.Stringid(m,0),cm.efilter,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,tp,tc)
	end
end