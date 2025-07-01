--孽驱伪理-「666」
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10700666)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)   
end
--e1
function cm.tgf1_M(c)
	return c:IsLevelAbove(1) and c:IsAbleToGrave() and c:IsFaceup()
end
function cm.RitualCheck(g,tp,c)
	return aux.RitualCheck(g,tp,c,c:GetLevel(),"Greater") and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 
		and (c:IsRace(RACE_FIEND) or g:IsExists(Card.IsAttribute,1,nil,c:GetAttribute()))
end
function cm.tgf12(c,e,tp,m1,m2)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() then return false end
	local mg=(m1:Filter(Card.IsCanBeRitualMaterial,c,c)+m2):Filter((c.mat_filter or aux.TRUE),c,tp)
	if not c:IsRace(RACE_FIEND) and not mg:IsExists(Card.IsAttribute,1,nil,c:GetAttribute()) then return false end
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,c:GetLevel(),"Greater")
	mg=mg:CheckSubGroup(cm.RitualCheck,1,c:GetLevel(),tp,c)
	Auxiliary.GCheckAdditional=nil
	return mg
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(cm.tgf1_M,tp,LOCATION_EXTRA,0,nil)
		return Duel.IsExistingMatchingCard(cm.tgf12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg,dg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(cm.tgf1_M,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.tgf12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg,dg):GetFirst()
	if not tc then return end
	mg=(mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)+dg):Filter((tc.mat_filter or aux.TRUE),tc,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
	mg=mg:SelectSubGroup(tp,cm.RitualCheck,false,1,tc:GetLevel(),tp,tc)
	aux.GCheckAdditional=nil
	if not mg or #mg==0 then
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return
	end
	tc:SetMaterial(mg)
	dg=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	if #dg>0 then
		mg:Sub(dg)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	end
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
end
--e2
function cm.drfilter(c)
	return c:IsCode(10700666) and c:IsAbleToDeck()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.drfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck()  and Duel.IsExistingTarget(cm.drfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,cm.drfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local d=tg:GetCount()
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)==0 then return end
	if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,d*500,REASON_EFFECT)
	end
end
