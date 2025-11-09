--天斎津波 2025/11/06 15:02:31 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--special summon self 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(this.spcost)
	e1:SetTarget(this.sptg)
	e1:SetOperation(this.spop)
	c:RegisterEffect(e1)
	--special summon 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+ofs)
	e2:SetTarget(this.sptg1)
	e2:SetOperation(this.spop1)
	c:RegisterEffect(e2)
end
function this.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_PYRO)
end
function this.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.spcostfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,this.spcostfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function this.spf(c,e,tp)
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)<1 then return false end 
	return c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function this.spgcheck(e,tp)
	local loc=LOCATION_DECK
	if e:GetHandler():IsAttribute(ATTRIBUTE_FIRE) then loc=loc+LOCATION_EXTRA end 
	local g=Duel.GetMatchingGroup(this.spf,tp,loc,0,nil,e,tp)
	return g
end 
function this.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=this.spgcheck(e,tp)
	if chk==0 then return e:GetHandler():IsReleasableByEffect() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
end
function this.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=this.spgcheck(e,tp)
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)>0 then 
		if #g>0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end
	
end
