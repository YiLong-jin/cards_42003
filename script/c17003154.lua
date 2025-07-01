--赛马娘 超级小海湾
function c17003154.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	   --atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c17003154.cfilter1)
	e1:SetCondition(c17003154.tgcon)
	c:RegisterEffect(e1)
	   --atk/def
  --cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c17003154.targetcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

end
function c17003154.tgcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c17003154.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x417) and not c:IsCode(17003154)
end

function c17003154.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x417)
end
function c17003154.targetcon(e)
	return Duel.IsExistingMatchingCard(c17003154.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end