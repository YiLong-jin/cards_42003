--天元晶龙 棱镜晶龙
local m=99920100
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,99920050,cm.Mffilter,1,true,true)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(cm.tgocon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.indoval)
	e4:SetCondition(cm.indocon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)

	--destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(cm.reptg)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(cm.eftg)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)

end
function cm.filter2(c,att)
	return c:IsAbleToGrave() and c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE)
	and Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND,0,nil,nil) end
	Duel.DiscardHand(tp,cm.filter2,1,1,REASON_COST+REASON_DISCARD,nil)
	return true
end

function cm.indocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)
end

function cm.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.tgocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  
end

function cm.eftg(e,c)
	return c:IsSetCard(0x6661) and c:IsType(TYPE_MONSTER)
end

function cm.Mffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x6661) and c:IsAttribute(ATTRIBUTE_EARTH)
end