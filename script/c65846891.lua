--超可爱执行者·夜魔女
function c65846891.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,65846891+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65846891.spcon)
	c:RegisterEffect(e1)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65846891.indtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
c65846891.SetCard_ZJ_CKAZXZ=true
function c65846891.indtg(e,c)
	return c.SetCard_ZJ_CKAZXZ and c:IsFaceup() and c~=e:GetHandler()
end
function c65846891.filter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsFaceup()
end
function c65846891.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846891.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end