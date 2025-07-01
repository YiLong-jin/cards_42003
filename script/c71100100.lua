--死者的舞台
local m=71100100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(cm.ctop)
	c:RegisterEffect(e0)
	--counter  
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_COUNTER) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e4:SetOperation(cm.ctop2)  
	c:RegisterEffect(e4)
	local e5=Effect.Clone(e4)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.Clone(e4)
	e6:SetCode(EVENT_FLIP)
	c:RegisterEffect(e6)
	--attack limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetValue(cm.atlimit)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7d8))
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(cm.tgval)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e10:SetRange(LOCATION_FZONE)
	e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e10:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7d8))
	e10:SetLabelObject(e9)
	c:RegisterEffect(e10)
end
function cm.ctfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x7d8)
end 
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	local tc=g:GetFirst()  
	while tc do 
			if tc:GetLevel()~=0 then
				local x=tc:GetLevel()
				tc:AddCounter(0x17d7,x)
			end
			if tc:IsType(TYPE_XYZ) then
				local y=tc:GetRank()
				tc:AddCounter(0x17d7,y)
			end
			if tc:IsType(TYPE_LINK) then
				local z=tc:GetLink()*2
				tc:AddCounter(0x17d7,z)
			end
		tc=g:GetNext()  
	end
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp) 
	local sg=eg:Filter(cm.ctfilter,nil)
	local tc=sg:GetFirst()  
	while tc do 
			if tc:GetLevel()~=0 then
				local x=tc:GetLevel()
				tc:AddCounter(0x17d7,x)
			end
			if tc:IsType(TYPE_XYZ) then
				local y=tc:GetRank()
				tc:AddCounter(0x17d7,y)
			end
			if tc:IsType(TYPE_LINK) then
				local z=tc:GetLink()*2
				tc:AddCounter(0x17d7,z)
			end
		tc=sg:GetNext()  
	end  
end
function cm.atlimit(e,c)
	return not c:GetColumnGroup():IsContains(e:GetHandler())
end
function cm.tgval(e,re,rp)
	return not re:GetHandler():GetColumnGroup():IsContains(e:GetHandler())
end