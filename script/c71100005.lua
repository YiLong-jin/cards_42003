--V城终结的泡影
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.datg)
	e2:SetOperation(cm.daop)
	c:RegisterEffect(e2)
end
function cm.filter(c,type)
	return c:IsFaceup() and c:IsSetCard(0x7d0) and c:IsType(type)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	for i,type in ipairs({TYPE_RITUAL,TYPE_FUSION,TYPE_LINK,TYPE_XYZ,TYPE_NORMAL}) do
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil,type) then
			ct=ct+1
		end
	end
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=0
	for i,type in ipairs({TYPE_RITUAL,TYPE_FUSION,TYPE_LINK,TYPE_XYZ,TYPE_NORMAL}) do
		if Duel.IsExistingMatchingCard(cm.filter,p,LOCATION_MZONE,0,1,nil,type) then
			ct=ct+1
		end
	end
	Duel.Draw(p,ct,REASON_EFFECT)
end
function cm.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
