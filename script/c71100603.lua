--爱丽丝的记忆碎片 2024/09/04 13:48:37 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(this.reptg)
	e2:SetValue(this.repval)
	e2:SetOperation(this.repop)
	c:RegisterEffect(e2)
end
function this.rmfilter(c)
	return c:IsSetCard(0x7d2) and c:IsAbleToRemove()
end
function this.setfilter(c)
	return c:IsCanTurnSet() and (not c:IsStatus(STATUS_LEAVE_CONFIRMED)) and (not c:IsSetCard(0x17a2))
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(this.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(this.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local sg=Duel.GetMatchingGroup(this.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #rg>0 and Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 and #sg>0 then 
		Duel.ChangePosition(sg,POS_FACEDOWN)
	end 
end
function this.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x17a2)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function this.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(this.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function this.repval(e,c)
	return this.repfilter(c,e:GetHandlerPlayer())
end
function this.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
