--白夜
function c10000120.initial_effect(c)
	aux.AddMaterialCodeList(c,10000120)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,10000120),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_ADD_RACE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff) 
	e0:SetValue(RACE_FAIRY) 
	c:RegisterEffect(e0) 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_ADD_ATTRIBUTE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff) 
	e0:SetValue(ATTRIBUTE_DARK) 
	c:RegisterEffect(e0) 
	--cannot be material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL) 
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0) 
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCondition(c10000120.espcon)
	e1:SetOperation(c10000120.espop)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION) 
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1) 
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(function(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0xafe2) end)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c10000120.xxtg)
	e2:SetOperation(c10000120.xxop)
	c:RegisterEffect(e2) 
	--atk def 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_SET_BASE_ATTACK) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTargetRange(LOCATION_MZONE,0) 
	e3:SetValue(function(e,c) 
	return c:GetBaseAttack()+1000 end) 
	c:RegisterEffect(e3) 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_SET_BASE_DEFENSE) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTargetRange(LOCATION_MZONE,0) 
	e3:SetValue(function(e,c) 
	return c:GetBaseDefense()+1000 end) 
	c:RegisterEffect(e3) 
	--to deck 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD) 
	e4:SetTarget(c10000120.tdtg)
	e4:SetOperation(c10000120.tdop)
	c:RegisterEffect(e4) 
end
function c10000120.ctdfil(c) 
	return c:IsAbleToDeckOrExtraAsCost() and c:IsCode(10000121,10000122,10000123,10000124)
end 
function c10000120.ctdgck(g,e,tp) 
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0 and g:GetClassCount(Card.GetCode)==g:GetCount() 
end 
function c10000120.espcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c10000120.ctdfil,tp,LOCATION_MZONE,0,nil) 
	return g:CheckSubGroup(c10000120.ctdgck,4,4,e,tp) 
end
function c10000120.espop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c10000120.ctdfil,tp,LOCATION_MZONE,0,nil) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c10000120.ctdgck,false,4,4,e,tp) 
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c10000120.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetChainLimit(c10000120.chlimit)
end
function c10000120.chlimit(e,ep,tp)
	return tp==ep
end 
function c10000120.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(10000121,10000122,10000123,10000124) 
end 
function c10000120.spgck(g,e,tp) 
	return g:GetClassCount(Card.GetCode)==g:GetCount() and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() 
end 
function c10000120.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,e:GetHandler())   
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local ag=Duel.GetMatchingGroup(c10000120.spfil,tp,LOCATION_DECK,0,nil,e,tp)
		if ag:CheckSubGroup(c10000120.spgck,4,4,e,tp) then  
			Duel.BreakEffect() 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=ag:SelectSubGroup(tp,c10000120.spgck,false,4,4,e,tp)   
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
end 
function c10000120.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,nil) 
	g:AddCard(e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end 
function c10000120.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,nil) 
	g:AddCard(e:GetHandler()) 
	if g:GetCount()>0 then 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 







