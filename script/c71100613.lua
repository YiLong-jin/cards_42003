--银翼凶星☆灾星龙·原初 2024/09/05 16:04:21 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70117860,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.spcon)
	e1:SetTarget(this.sptg)
	e1:SetOperation(this.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+ofs)
	e2:SetTarget(this.exsptg)
	e2:SetOperation(this.exspop)
	c:RegisterEffect(e2)
end
function this.cfilter2(c)
	return c:IsFacedown() or (not c:IsType(TYPE_LINK))
end
function this.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(this.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function this.thfilter(c)
	return (c:IsSetCard(0x7d4) or c:IsSetCard(0x7db)) and c:IsAbleToHand()
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(this.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,this.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function this.chkfilter(c,e,tp,mg)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x7d5) and c:IsLinkBelow(4) 
	and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function this.lsf(c,e,tp,rc)
	local mg=Group.FromCards(c,rc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x7d4) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(this.chkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function this.exsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(this.lsf,tp,LOCATION_MZONE,0,1,c,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,LOCATION_MZONE)
end
function this.exspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lsg=Duel.GetMatchingGroup(this.lsf,tp,LOCATION_MZONE,0,c,e,tp,c)
	if #lsg<1 or not (c:IsRelateToEffect(e) and c:IsAbleToGrave()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=lsg:Select(tp,1,1,nil)
	tg1:AddCard(c)
	local exg=Duel.GetMatchingGroup(this.chkfilter,tp,LOCATION_EXTRA,0,nil,e,tp,tg1)
	if Duel.SendtoGrave(tg1,REASON_EFFECT)==2 and #exg>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=exg:Select(tp,1,1,nil)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
