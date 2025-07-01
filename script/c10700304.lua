--卫兵皇家骑士
function c10700304.initial_effect(c)
	aux.AddCodeList(c,90876561)
	--code
	aux.EnableChangeCode(c,90876561,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2801664,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,10700304)
	e3:SetCondition(c10700304.spcon)
	e3:SetTarget(c10700304.sptg)
	e3:SetOperation(c10700304.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2801664,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	e4:SetCountLimit(1,10700304)
	e4:SetCondition(c10700304.spcon2)
	e4:SetTarget(c10700304.sptg)
	e4:SetOperation(c10700304.spop)
	c:RegisterEffect(e4)  
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700300,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,10700305)
	e5:SetCondition(c10700304.drcon)
	e5:SetTarget(c10700304.drtg)
	e5:SetOperation(c10700304.drop)
	c:RegisterEffect(e5)   
end
function c10700304.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end
function c10700304.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c10700304.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700304.cfilter,tp,LOCATION_MZONE,0,2,nil) and not Duel.IsPlayerAffectedByEffect(tp,10700309)
end
function c10700304.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700304.cfilter,tp,LOCATION_MZONE,0,2,nil) and Duel.IsPlayerAffectedByEffect(tp,10700309)
end
function c10700304.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10700304.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10700304.drcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re and re:IsActivated()) then return false end
	return e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_COST) 
end
function c10700304.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700304.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end