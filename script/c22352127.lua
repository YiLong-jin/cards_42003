--双剑高驱动骑士
function c22352127.initial_effect(c)
	aux.AddLinkProcedure(c,c22352127.matfilter,2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c22352127.matcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c22352127.regcon)
	e2:SetOperation(c22352127.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(c22352127.attchange)
	c:RegisterEffect(e3)
end
function c22352127.matfilter(c,lc,sumtype,tp)
	return c:IsLinkSetCard(0xc29) and c:IsType(TYPE_LINK)
end


function c22352127.matcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0xc29)
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetOriginalAttribute())
		tc=g:GetNext()
	end
	e:SetLabel(att)
end

function c22352127.attchange(e,c)
	local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0xc29)
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetOriginalAttribute())
		tc=g:GetNext()
	end
	return att
end
function c22352127.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end




function c22352127.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c22352127.aclimit)
	e1:SetLabelObject(e:GetLabelObject())
	c:RegisterEffect(e1)
	local att=e:GetLabelObject():GetLabel()
	if bit.band(att,ATTRIBUTE_EARTH)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22352127,2))
	end
	if bit.band(att,ATTRIBUTE_WATER)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22352127,3))
	end
	if bit.band(att,ATTRIBUTE_FIRE)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22352127,4))
	end
	if bit.band(att,ATTRIBUTE_WIND)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22352127,5))
	end
	if bit.band(att,ATTRIBUTE_LIGHT)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22352127,6))
	end
	if bit.band(att,ATTRIBUTE_DARK)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22352127,7))
	end
	if bit.band(att,ATTRIBUTE_DIVINE)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22352127,8))
	end
end
function c22352127.aclimit(e,re,tp)
	local att=e:GetLabelObject():GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and bit.band(att,re:GetHandler():GetOriginalAttribute())~=0
end



