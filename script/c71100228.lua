--V城之下的傀儡
local m=71100228
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6039967,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.postg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--pos
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	e5:SetLabel(0,0)
	c:RegisterEffect(e5)
end
function cm.postg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.atkupf(c)
	return  c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bg=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	return Duel.IsExistingMatchingCard(cm.atkupf,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and bg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) and bg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=Duel.GetAttacker()
	if c:IsControler(1-tp) then c=Duel.GetAttackTarget() end
	local ct=Duel.GetMatchingGroupCount(cm.atkupf,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(ct*500)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct_self=eg:FilterCount(cm.cfilter,nil,tp)
	local ct_oppo=eg:FilterCount(cm.cfilter,nil,1-tp)
	local ct1,ct2=e:GetLabel()
	e:SetLabel(ct1+ct_self,ct2+ct_oppo)
	local ct1,ct2=e:GetLabel()
	return ct1>=6 and ct2>=6
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function cm.spf(c,e,tp)
	return cm.postg(e,c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(cm.spf,tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end