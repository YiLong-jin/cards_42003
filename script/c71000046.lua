--真正的赌神
local m=71000046
local cm=_G["c"..m]
function cm.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2196767,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge0:SetCode(EVENT_PREDRAW)
	ge0:SetRange(0xff)
	ge0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	ge0:SetOperation(cm.checkop)
	c:RegisterEffect(ge0)
	if not cm.global_check then
		cm.global_check=true
		local tp=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ge1:SetTargetRange(1,0)
		ge1:SetCondition(cm.con)
		ge1:SetTarget(cm.sumlimit)
		Duel.RegisterEffect(ge1,tp)
		local ge2=ge1:Clone()
		ge2:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(ge2,tp)
		local ge3=ge1:Clone()
		ge3:SetCode(EFFECT_CANNOT_SSET)
		Duel.RegisterEffect(ge3,tp)
		local ge4=ge1:Clone()
		ge4:SetCode(EFFECT_CANNOT_TURN_SET)
		Duel.RegisterEffect(ge4,tp)
		local ge5=ge1:Clone()
		ge5:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(ge5,tp)
		local ge6=ge1:Clone()
		ge6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		Duel.RegisterEffect(ge6,tp)
		local ge7=ge1:Clone()
		ge7:SetCode(EFFECT_CANNOT_ACTIVATE)
		ge7:SetValue(cm.aclimit)
		Duel.RegisterEffect(ge7,tp)
		local ge8=ge1:Clone()
		ge8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		ge8:SetCode(EFFECT_DISABLE)
		ge8:SetTargetRange(0xff,0)
		Duel.RegisterEffect(ge8,tp)
		local ge9=ge8:Clone()
		ge9:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		Duel.RegisterEffect(ge9,tp)
		local ge10=Effect.CreateEffect(c)
		ge10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge10:SetProperty(ge8:GetProperty())
		ge10:SetCode(EVENT_CHAIN_SOLVING)
		ge10:SetCondition(cm.discon)
		ge10:SetOperation(cm.disop)
		Duel.RegisterEffect(ge10,tp)
	end
end
cm.toss_coin=true
function cm.filter(c)
	if c:IsSetCard(0x973) then return false end
	return c.toss_coin or c.toss_dice or c:IsCode(71344451,43575579)
end
function cm.sumlimit(e,c)
	return not cm.filter(c)
end
function cm.aclimit(e,re,tp)
	return not cm.filter(re:GetHandler())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(re:GetHandler():GetControler(),m)>0 and not cm.filter(re:GetHandler())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ConfirmCards(tp,e:GetHandler())
	Duel.RegisterFlagEffect(tp,m,0,0,99)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif c1+c2+c3==2 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	elseif c1+c2+c3==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end