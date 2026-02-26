--驱动空天救世主-八宵
function c9879360.initial_effect(c)
	aux.AddCodeList(c,9879202,9879279)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),c9879360.ntfilter,1,1)
	c:EnableReviveLimit() 
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879360,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9879360)
	e3:SetCondition(c9879360.remcon)
	e3:SetTarget(c9879360.destg)
	e3:SetOperation(c9879360.desop)
	c:RegisterEffect(e3)
	
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879270,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1879360)
	e2:SetTarget(c9879360.target)
	e2:SetOperation(c9879360.operation)
	c:RegisterEffect(e2)
end
function c9879360.ntfilter(c)
	return not c:IsType(TYPE_TUNER) and aux.IsCodeListed(c,9879202)
end

function c9879360.ctfil(c,e,tp)
	return c:IsFaceup() and c:IsCode(9879279) and Duel.IsExistingMatchingCard(c9879360.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) 
end
function c9879360.spfil(c,e,tp,sc)
	return aux.IsCodeListed(c,9879202) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0   
end 
function c9879360.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9879360.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9879360.ctfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c9879360.ctfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9879360.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c9879360.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,tc)
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and g:GetCount()>0 then 
	local sc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)   
	end 
end



function c9879360.tfilter(c,att,e,tp,tc)
	return c.kotian and c:IsCode(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c9879360.filter(c,e,tp)
	return c:IsFaceup() and aux.IsCodeListed(c,9879202)
		and Duel.IsExistingMatchingCard(c9879360.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetCode(),e,tp,c)
end
function c9879360.chkfilter(c,att)
	return c:IsFaceup() and aux.IsCodeListed(c,9879202) and (c:GetCode()&att)==att
end
function c9879360.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9879360.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c9879360.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9879360.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(g:GetFirst():GetCode())
end
function c9879360.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetCode()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9879360.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end