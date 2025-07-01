--电脑堺餮-饕饕
function c88884199.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88884199,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,c88884199)
	e1:SetTarget(c88884199.sptg)
	e1:SetOperation(c88884199.spop)
	c:RegisterEffect(e1)
end
function c88884199.tfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x14e) and c:IsFaceup() and Duel.IsExistingMatchingCard(c88884199.tgfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function c88884199.tgfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x14e) and c:IsAbleToGrave()
end
function c88884199.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c88884199.tfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,