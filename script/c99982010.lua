--神谕庭院前台 见习死神特莉波卡
local m=99982010
local cm=_G["c"..m]
function cm.initial_effect(c)

	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99982010,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99982011)
	e3:SetCondition(c99982010.sccon)
	e3:SetTarget(c99982010.sctg)
	e3:SetOperation(c99982010.scop)
	c:RegisterEffect(e3)   



	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99982010,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99982010)
	e1:SetCost(c99982010.sumcost)
	e1:SetTarget(c99982010.sumtg)
	e1:SetOperation(c99982010.sumop)
--	c:RegisterEffect(e1)	

end
c99982010.fusion_effect=true
function c99982010.filter(c,e,tp,mg)
	if c:GetLevel()>4 then return false end
	local ct=math.floor(c:GetLevel())
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x66d) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mg:CheckSubGroup(c99982010.gcheck,ct,ct,tp,c)
end
function c99982010.gcheck(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
		and g:FilterCount(Card.IsAbleToGrave,nil)==g:GetCount()
end
function c99982010.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,0x66d)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c99982010.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99982010.scop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,0x66d)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99982010.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local ct=math.floor(tc:GetLevel())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=mg:SelectSubGroup(tp,c99982010.gcheck,false,ct,ct,tp,tc)
		local cg=sg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=0 then
			tc:SetMaterial(nil)
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
				tc:CompleteProcedure()
			end
		end
	end
end

function c99982010.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end


-----------------------------------------------------------------------------------------------

function c99982010.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c99982010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c99982010.sumop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
end

