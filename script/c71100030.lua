--公司高层
local m=71100030
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,cm.lcheck)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1) 
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(71100031)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.cetg)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,m) 
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.lckeckm(c)
	return c:IsLinkType(TYPE_XYZ) and c:IsSetCard(0x7d0)
end
function cm.lckecks(c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.lcheck(g)
	return g:IsExists(cm.lckeckm,1,nil) and not g:IsExists(cm.lckecks,1,nil)
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7d0)
end
function cm.tgcon(e)
	return Duel.IsExistingMatchingCard(cm.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.cetg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x7d0)
end 
function cm.spfilter1(c,e,tp)
	return c:IsSetCard(0x7d0) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter1),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,LOCATION_GRAVE+LOCATION_EXTRA)
end 
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter1),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xc=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
		xc:CancelToGrave()
		Duel.Overlay(tc,xc)
	end
end













