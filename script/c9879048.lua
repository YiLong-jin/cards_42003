--站立！这就是正义！
function c9879048.initial_effect(c)
	aux.AddCodeList(c,9879042)

	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_ACTIVATE) 
	e0:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e0) 

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879048,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1) 
	e1:SetTarget(c9879048.sptg)
	e1:SetOperation(c9879048.spop)
	c:RegisterEffect(e1) 


	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879048,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9879048)
	e3:SetCondition(c9879048.sccon)
	e3:SetTarget(c9879048.sctg)
	e3:SetOperation(c9879048.scop)
	c:RegisterEffect(e3)
end
function c9879048.spfilter(c,e,tp)
	return aux.IsCodeListed(c,9879042) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9879048.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9879048.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879048.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end 
end


function c9879048.scconfilter(c,tp)
	return c:IsFaceup()
end
function c9879048.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9879048.scconfilter,1,nil,tp)
end
function c9879048.mfilter(c)
	return aux.IsCodeListed(c,9879042) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c9879048.syncheck(g,tp,syncard)
	return g:IsExists(c9879048.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c9879048.scfilter(c,tp,mg)
	return mg:CheckSubGroup(c9879048.syncheck,2,#mg,tp,c)
end
function c9879048.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		return Duel.IsExistingMatchingCard(c9879048.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9879048.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local g=Duel.GetMatchingGroup(c9879048.scfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,c9879048.syncheck,false,2,#mg,tp,sc)
		Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
	end
end