--玉 莲 帮 密 探
function c10203013.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c10203013.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10203013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10203013)
	e1:SetCondition(c10203013.spcon)
	e1:SetCost(c10203013.spcost)
	e1:SetTarget(c10203013.sptg)
	e1:SetOperation(c10203013.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10203013,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,102030131)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10203013.target)
	e2:SetOperation(c10203013.activate)
	c:RegisterEffect(e2)
end
function c10203013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10203013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(10203013,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10203013.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c10203013.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:GetAttribute()~=ATTRIBUTE_WIND
end
function c10203013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 end
	Duel.SetTargetPlayer(tp)
end
function c10203013.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.GetFieldGroupCount(p,0,LOCATION_DECK)<3 then return end
	Duel.ConfirmDecktop(1-p,3)
	local g=Duel.GetDecktopGroup(1-p,3)
	local ct=g:GetCount()
	if ct>2 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(10203013,0))
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoHand(sg:GetFirst(),tp,1)
		Duel.ConfirmCards(1-p,sg)
		Duel.SortDecktop(p,1-p,ct-1)
		Duel.ConfirmDecktop(1-p,ct-1)
	end
end
function c10203013.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xe79e) or g:IsExists(Card.IsLinkCode,1,nil,10203001)
end
function c10203013.spfilter(c,e,tp)
	return c:IsCode(10203001) or c:IsSetCard(0xe79e) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10203013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10203013.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10203013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HANDLOCATION_HAND+LOCATION_GRAVE,0,1,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)

	local g=Duel.SelectMatchingCard(tp,c10203013.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
