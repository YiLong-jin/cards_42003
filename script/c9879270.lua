--驱动空天变身-三宵
c9879270.kotian=true
function c9879270.initial_effect(c)
	aux.AddCodeList(c,9879202,9879208,9879204)
	c:EnableReviveLimit()

	aux.EnableChangeCode(c,9879204,LOCATION_EXTRA)


	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9879270.splimit)
	c:RegisterEffect(e0)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c9879270.discon)
	e4:SetOperation(c9879270.disop)
	c:RegisterEffect(e4)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879270,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9879270)
	e2:SetTarget(c9879270.target)
	e2:SetOperation(c9879270.operation)
	c:RegisterEffect(e2)
	
end
function c9879270.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(9879208)
end

function c9879270.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and aux.IsCodeListed(c,9879202) and c:IsSummonLocation(LOCATION_EXTRA) and seq1==4-seq2 and not c:IsType(TYPE_FUSION)
end
function c9879270.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL) and loc&LOCATION_SZONE==LOCATION_SZONE and seq<=4 and Duel.IsExistingMatchingCard(c9879270.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c9879270.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9879270)
	Duel.NegateEffect(ev)
end

function c9879270.spfil(c,e,tp)
	return c:GetAttack()==c:GetDefense() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879270.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9879270.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9879270.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9879270.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end